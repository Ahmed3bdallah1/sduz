# SUDZ Backend Implementation Plan

## 1. Vision & Scope
- Deliver a production-grade Laravel + MySQL backend that powers the SUDZ mobile app for clients and technicians, and provides admin tooling.
- Support subscription packages, on-demand bookings, e-commerce store, and technician workflows with evidence capture.
- Guarantee secure authentication, role-based authorization, localized content, real-time updates, and offline resilience.
- Integrate online payments, notifications, and contextual chat tied to active service requests.

## 2. Technology Stack
- **Framework:** Laravel 11 (PHP 8.2) with modular structure (`app/Modules/*`) mirroring Flutter features.
- **Database:** MySQL 8.x with strict mode; Redis for queues, cache, broadcast presence, and rate limiting.
- **Auth & Security:** Laravel Sanctum for token auth, spatie/laravel-permission for RBAC (client, technician, admin), hashed PII, audit logging.
- **Real-time:** Laravel WebSockets (self-hosted) or Pusher; Laravel Echo for broadcasting.
- **Media Storage:** S3-compatible bucket (e.g., AWS S3 or Wasabi) with signed URL delivery and CDN caching.
- **Payments:** Gateway abstraction (Tap/Hyperpay/STC Pay) with PCI-compliant tokenization, webhooks, refunds.
- **Infrastructure:** Docker Compose for local dev (nginx, php-fpm, mysql, redis, websocket server), Horizon for queues, Telescope in non-prod.

## 3. Core Modules & Responsibilities
| Module | Key Features |
| --- | --- |
| Identity & Access | Registration, phone OTP verification, login/logout, password recovery, device tokens, session revocation. |
| Profiles & Preferences | User profiles, social links, localization, addresses, saved settings. |
| Cars | CRUD for vehicles, photos, default selection. |
| Catalog & Packages | Services, steps, pricing, packages, benefits, availability rules, promotions. |
| Booking & Scheduling | Slot discovery, booking creation, status machine, package deduction, notifications. |
| Payments | Payment intent lifecycle, card vaulting, 3DS support, webhook reconciliation, refunds. |
| Technician Workspace | Assignment management, geo-validated arrival, evidence uploads, offline sync, timelines, performance tracking, earnings & tips management. |
| Chat | Threaded conversations per booking between admin, client, technician with real-time delivery. |
| Store & Commerce | Categories, products, carts, checkout, order management, inventory hooks. |
| Dedications | Gift flows, recipient notifications, admin oversight. |
| Ratings & Tips | Customer ratings of technicians (5-star with sub-scores), tip payments, technician performance analytics. |
| Service Areas | Geographic coverage zones with polygon boundaries, RTL address support (Arabic-first). |
| Notifications & Messaging | Push, SMS, email templates with localization (Arabic/English). |
| Admin Console | Role management, bookings oversight, content management, reporting dashboards. |
| Analytics & Reporting | KPIs (booking success, technician performance, sales, package usage, ratings analytics, tip tracking). |

## 4. Business Workflows
1. **Customer Booking Flow**
   - Discover services → choose car → select slot → confirm booking.
   - Payment path: package deduction or online payment intent (card/COD fallback).
   - Booking state transitions: Requested → Confirmed → In Progress → Completed → Pending Review → Closed; cancellation/rejection branches.
2. **Technician Flow**
   - Receives assignment, views details & maps.
   - Marks arrival (geo radius check) → uploads ≥5 pre-work photos → start work → uploads ≥5 post-work photos → complete job.
   - Offline updates queued; backend reconciles on sync.
3. **Admin Oversight**
   - Assign/override technicians, adjust schedules, review evidence, close bookings, moderate chat, handle disputes.
4. **Store Checkout**
   - Cart management → checkout → payment intent → order fulfillment → inventory update.
5. **Dedication Flow**
   - Client selects gift type → enters recipient details → triggers payment (if paid gift) → sends SMS/push to recipient → admin dashboard monitors status.
6. **Rating & Tip Flow**
   - After booking completion → customer receives prompt to rate service.
   - Customer provides: overall rating (1-5 stars), sub-ratings (quality, punctuality, professionalism, cleanliness), optional review text (Arabic/English).
   - Customer can optionally add tip (predefined amounts: 5, 10, 20 SAR or custom amount).
   - Tip payment processed via saved payment method or new payment intent.
   - Rating immediately updates technician's average score and summary stats.
   - Tip added to technician's pending earnings; paid out according to payout schedule.
   - Technician receives notification of new rating and tip with thank you message.

## 5. Data Model Blueprint
### Identity & Access
- `users` (role, phone, email, status, last_login_at, locale).
- `roles`, `model_has_roles` (from spatie).
- `user_profiles` (name, title, bio, social links, avatar).
- `user_devices` (fcm_token, platform, last_seen_at).
- `otp_requests` (phone, code, expires_at, attempts, consumed_at).

### Customer Domain
- `addresses` (title, description, lat, lng, is_service_area, city, district, street_name, building_number, postal_code, special_instructions, address_ar, address_en).
- `user_addresses` (user_id, address_id, is_default, address_type enum home/work/other).
- `cars` (user_id, make, model, color, plate_number, image_path, is_primary).
- `car_media` (car_id, path, order, metadata).
- `service_areas` (name_ar, name_en, city, polygon_coordinates_json, is_active, min_order_amount).

### Catalog & Packages
- `services` (slug, name_key, description_key, base_price, duration, is_active).
- `service_steps` (service_id, order, title_key, description_key).
- `service_addons` (service_id, title_key, price, duration_delta, is_active).
- `packages` (service_id nullable, name_key, price, washes, validity_days, is_recommended).
- `package_benefits` (package_id, description_key, order).
- `package_purchases` (user_id, package_id, price_paid, started_at, expires_at, status).
- `package_credits` (purchase_id, remaining_washes, remaining_days_snapshot).

### Booking & Scheduling
- `bookings` (client_id, service_id, car_id, address_id, scheduled_start, scheduled_end, status, payment_status, payment_method, total_amount, package_purchase_id nullable, technician_id nullable).
- `booking_items` (booking_id, addon_id, price).
- `booking_status_history` (booking_id, status, actor_id, role, note, created_at).
- `booking_notes` (booking_id, author_id, body, visibility).
- `availability_rules` (service_id/area, day_of_week, start_time, end_time, capacity).
- `time_slots` (rule_id, date, start_at, end_at, capacity, remaining).
- `slot_reservations` (slot_id, user_id, booking_id nullable, expires_at).

### Ratings & Tips
- `booking_ratings` (booking_id, technician_id, client_id, rating 1-5, quality_score 1-5, punctuality_score 1-5, professionalism_score 1-5, cleanliness_score 1-5, review_text, review_text_ar nullable, created_at).
- `technician_tips` (booking_id, technician_id, client_id, tip_amount, payment_status enum pending/paid/failed, payment_intent_id nullable, paid_at, created_at).
- `technician_ratings_summary` (technician_id, total_ratings, average_rating, average_quality, average_punctuality, average_professionalism, average_cleanliness, last_updated_at).
- `technician_earnings` (technician_id, booking_id, base_payment, tip_amount, total_earned, payment_date, status enum pending/paid).

### Technician Operations
- `job_assignments` (booking_id, technician_id, assigned_by_id, assigned_at, accepted_at).
- `job_states` (assignment_id, current_status, arrived_at, work_started_at, work_completed_at, override_note).
- `job_media` (assignment_id, category enum pre_work/post_work/rejection, path, thumb_path, uploaded_by, uploaded_at, checksum).
- `job_rejections` (assignment_id, reason, noted_by, created_at).
- `job_pending_actions` (assignment_id, action_kind, payload, is_synced).
- `job_timeline` (assignment_id, status, actor_id, note, occurred_at).
- `technician_performance` (technician_id, date, completed_jobs, total_earnings, total_tips, average_rating, on_time_percentage, rejection_count).

### Chat
- `chat_threads` (booking_id, opened_by_id, status enum open/closed, opened_at, closed_at).
- `chat_participants` (thread_id, user_id, role, last_read_at).
- `chat_messages` (thread_id, sender_id, message_type enum text/image/system, body_json, sent_at, delivery_state).
- `chat_attachments` (message_id, path, mime_type, size_bytes, metadata_json).
- `chat_flags` (message_id, reported_by_id, reason, resolved_at).

### Payments
- `payment_methods` (user_id, gateway enum tap/tabby, gateway_reference, brand visa/mastercard/mada, last4, exp_month, exp_year, is_default, created_at).
- `payment_intents` (payable_type booking/order, payable_id, amount, currency default SAR, status enum pending/processing/succeeded/failed/canceled, gateway enum tap/tabby, gateway_reference, client_secret, capture_method enum automatic/manual, metadata_json, created_at, updated_at).
- `payment_attempts` (intent_id, status enum pending/succeeded/failed, error_code, error_message, gateway_response_json, processed_at).
- `refunds` (intent_id, amount, reason, status enum pending/succeeded/failed, gateway_reference, processed_by_id admin, processed_at).
- `payment_webhooks` (gateway enum tap/tabby, event_type, payload_json, signature, status enum received/processed/failed, processed_at, error_message).
- `tabby_installments` (intent_id, installment_number, amount, due_date, status enum pending/paid/failed, paid_at).
- `payment_fees` (intent_id, fee_amount, fee_percentage, gateway_fee, net_amount calculated).

### Store
- `store_categories` (name_key, slug, is_active, display_order).
- `store_products` (category_id, name_key, description_key, price, old_price, stock_qty, is_active).
- `product_media` (product_id, path, type, order).
- `carts` (user_id, status, updated_at).
- `cart_items` (cart_id, product_id, quantity, unit_price).
- `store_orders` (user_id, cart_snapshot_json, status, total_amount, payment_intent_id).
- `order_items` (order_id, product_id, name_snapshot, quantity, unit_price).
- `shipping_addresses` (order_id, address_snapshot_json).

### Dedications & Support
- `dedication_types` (name_key, price, is_paid).
- `dedications` (sender_id, recipient_phone, message, status, payment_intent_id nullable).
- `dedication_notifications` (dedication_id, channel, status, sent_at).
- `support_tickets`, `activity_logs`, `content_blocks`, `app_settings`.

## 6. API Blueprint
- **Auth:** `/api/auth/register`, `/api/auth/login`, `/api/auth/logout`, `/api/auth/otp/send|verify`, `/api/auth/password/forgot|reset`, `/api/auth/me`, `/api/auth/profile` (GET/PATCH), `/api/auth/devices`.
- **Profiles & Cars:** `/api/profile`, `/api/profile/addresses` (CRUD), `/api/cars` (CRUD + `/primary`).
- **Catalog & Packages:** `/api/services`, `/api/services/{id}`, `/api/services/{id}/slots`, `/api/packages`, `/api/packages/{id}/purchase`, `/api/packages/active`.
- **Bookings:** `/api/bookings` (POST, GET list), `/api/bookings/{id}` (GET, PATCH for schedule/cancel), `/api/bookings/{id}/status`, `/api/bookings/{id}/notes`, `/api/bookings/{id}/rate` (POST with rating + review + optional tip), `/api/bookings/{id}/tip` (POST add tip after rating).
- **Payments:** `/api/payments/intent` (POST create with payment_method: card/apple_pay/tabby/package), `/api/payments/{intent}` (GET status), `/api/payments/{intent}/confirm` (POST for Apple Pay completion), `/api/payments/{intent}/cancel` (POST), `/api/payments/methods` (GET saved cards, POST add, DELETE remove), `/api/payments/methods/{id}/default` (PATCH set default), `/api/webhooks/tap` (POST), `/api/webhooks/tabby` (POST).
- **Technician:** `/api/tech/jobs`, `/api/tech/jobs/{id}`, `/api/tech/jobs/{id}/arrive|start|complete|reject`, `/api/tech/jobs/{id}/evidence` (multipart), `/api/tech/jobs/{id}/timeline`, `/api/tech/jobs/{id}/sync`, `/api/tech/performance` (GET stats with ?period=day|week|month|year), `/api/tech/performance/daily` (GET daily breakdown), `/api/tech/performance/monthly` (GET monthly breakdown), `/api/tech/earnings` (GET with ?start_date&end_date), `/api/tech/ratings` (GET rating history with pagination), `/api/tech/tips` (GET tip history).
- **Chat:** `/api/chats?scope=open|closed`, `/api/chats/{booking}/open`, `/api/chats/{thread}/messages` (GET cursor, POST create), `/api/chats/{thread}/attachments`, `/api/chats/{thread}/read`, `/api/chats/{thread}/typing`, `/api/admin/chats/{thread}/close`.
- **Store:** `/api/store/categories`, `/api/store/products`, `/api/store/cart/items`, `/api/store/checkout`, `/api/store/orders`.
- **Dedications & Content:** `/api/dedications/types`, `/api/dedications`, `/api/home`.
- **Admin:** `/api/admin/bookings`, `/api/admin/jobs/{booking}/assign`, `/api/admin/reports/*`, `/api/admin/payments/refunds`.
- **Notifications:** `/api/notifications` (list, mark read), `/api/notifications/subscribe`.

API responses shaped via Laravel API Resources to match Flutter DTOs; versioning via `/api/v1/` prefix.

## 7. Real-Time Chat Strategy
- **Thread Lifecycle:** Auto-open on booking status `confirmed` or admin command; participants limited to booking client, assigned technician, admins; auto-close on booking closure with read-only archive.
- **Transport:** Laravel WebSockets or Pusher with private channels `private-chat.thread.{id}`; fallback long-poll endpoint for unreliable connections.
- **Features:** Typing indicators, delivery receipts, offline queue, attachment uploads (images), profanity filter pipeline, message flagging for moderation.
- **Notifications:** Push + optional SMS/email for unread messages after threshold; admin dashboard surfaces unread threads.
- **Security:** Channel auth ensures only participants subscribe; signed URLs for attachments; audit trail via `chat_flags` and `activity_logs`.

## 8. Online Payments Strategy

### Payment Methods Supported (KSA Market)
1. **Card Payments (via Tap Payments)**
   - Visa, Mastercard, Mada (Saudi local cards)
   - 3D Secure (3DS) authentication support
   - Card tokenization for saved payment methods
   
2. **Apple Pay (via Tap Payments)**
   - Native iOS integration using Tap Flutter SDK
   - Seamless one-tap checkout experience
   - Requires Apple Developer merchant ID registration
   
3. **Tabby (Buy Now Pay Later)**
   - Split payments into 4 interest-free installments
   - Separate API integration (tabby.ai)
   - Automatic bi-weekly charges
   - Min/Max: 50-10,000 SAR per transaction
   
4. **Package Credits**
   - Prepaid wash packages with deduction logic
   - No payment gateway involved for package-based bookings

### Technical Implementation
- **Primary Gateway:** Tap Payments (tap.company) for cards and Apple Pay
- **Secondary Gateway:** Tabby for BNPL (Buy Now Pay Later)
- Implement `PaymentGatewayInterface` with drivers: `TapGateway`, `TabbyGateway`
- Payment intent lifecycle: Create → Process → Webhook Confirmation → Capture/Refund
- Frontend obtains payment tokens and completes via native SDKs (Tap Flutter SDK for Apple Pay)
- Webhook processors validate signatures, update `payment_intents`, reconcile bookings/orders, trigger notifications
- Support saved cards via Tap's customer vault with tokenization
- Refund API for admin with gateway-specific refund handlers
- Scheduled reconciliation job compares gateway statements with local payment records
- Transaction fee tracking per payment method (Mada: ~1.5%, Visa/MC: ~2.5%, Tabby: ~3-4%)

### Security & Compliance
- PCI-DSS Level 1 compliance via Tap (no raw card data stored)
- Store only gateway tokens and last4 digits for display
- Webhook signature verification for Tap (HMAC-SHA256) and Tabby
- HTTPS enforcement for all payment endpoints
- Rate limiting on payment creation (prevent abuse)
- Comprehensive audit logging for all payment state changes
- Idempotency keys to prevent duplicate charges
- Payment intent expiration (30 minutes from creation)

## 9. Cross-Cutting Concerns
- **Validation:** Laravel Form Requests with localization; consistent error envelopes (`code`, `message`, `details`).
- **Observability:** Structured logging (Monolog JSON), Sentry/Bugsnag integration, metrics export via Prometheus-compatible endpoint, health checks.
- **Security:** Rate-limiting (per IP/phone), CSRF protection for admin panel, signed routes for sensitive actions, encryption of sensitive fields.
- **Internationalization:** **Arabic-first design** with RTL support; Store translation keys in database fields; API returns keys plus fallback text; Arabic and English for all customer-facing content; admin console manages content.
- **Address Management:** Support for KSA address format (city, district, building number, postal code); Arabic and English address fields; Service area polygon validation; Special instructions field for landmarks.
- **Technician Performance Tracking:** 
  - Real-time statistics dashboard showing daily/weekly/monthly performance
  - Completed jobs count with time-based filtering
  - Total earnings breakdown (base pay + tips)
  - Average rating with trend analysis (improving/declining)
  - Sub-ratings visualization (quality, punctuality, professionalism, cleanliness)
  - Tips received history with customer feedback
  - On-time arrival percentage
  - Job rejection rate and reasons
  - Customer satisfaction score (percentage of 4-5 star ratings)
- **Rating Analytics:**
  - Aggregate technician ratings updated in real-time after each customer review
  - Rating trends over time (daily, weekly, monthly)
  - Review text sentiment tracking (optional: Arabic NLP)
  - Response rate to customer feedback
  - Badge/achievement system based on ratings (Top Rated, Punctuality Pro, Quality Expert)
- **Testing:** PHPUnit + Pest for unit/feature tests, HTTP tests for endpoints, Dusk for admin UI, contract tests for Flutter integration (OpenAPI).
- **Documentation:** Auto-generate OpenAPI spec (using `knuckleswtf/scribe` or `l5-swagger`), ERD diagrams, deployment runbooks.

## 10. Infrastructure & DevOps
- **Environments:** Dev (Docker), Staging, Production with CI/CD (GitHub Actions).
- **CI Pipeline:** lint (PHP-CS-Fixer), static analysis (Larastan), tests, build Docker image, deploy via GitOps or artifact push.
- **Secrets Management:** `.env` templating, managed secrets (AWS Secrets Manager or Laravel Vapor alternatives).
- **Monitoring:** Horizon dashboard, queue alerting, uptime monitoring, log aggregation via CloudWatch/ELK.
- **Backups & DR:** Automated MySQL backups (point-in-time), S3 versioned storage, retention policies, restore playbooks.

## 11. Implementation Roadmap
1. **Phase 0 – Foundations (Week 1)**
   - Repo setup, Docker baseline, CI skeleton, code style tooling.
   - Shared kernel (`Domain`, `Support` utilities), base migrations (users, roles).
2. **Phase 1 – Identity & Profile (Weeks 2-3)**
   - Auth module (register/login/OTP/password reset), device tokens, profile CRUD, addresses with Arabic/English support, cars.
   - Service area management with polygon boundaries.
   - Unit & feature tests, localization scaffolding (Arabic-first).
3. **Phase 2 – Catalog, Packages & Scheduling (Weeks 4-6)**
   - Services, packages, availability rules, slot API, booking creation, package deduction logic.
   - Service area validation for addresses.
   - Notification stubs, admin assignment endpoints, initial admin UI scaffolding.
4. **Phase 3 – Payments & Checkout (Weeks 6-8)**
   - `PaymentGatewayInterface` and driver implementations for Tap (cards + Apple Pay) and Tabby (BNPL)
   - Payment intent creation, webhook signature verification, status reconciliation
   - Saved card management (tokenization via Tap customer vault)
   - Apple Pay configuration and merchant certificate setup
   - Tabby session creation and installment tracking
   - Refund workflows for admin panel
   - Package credit deduction logic integration
   - Payment fee calculation and tracking
   - Integrate with store checkout; scheduled reconciliation job
   - Comprehensive payment state machine tests
5. **Phase 4 – Technician Module (Weeks 8-10)**
   - Technician job endpoints, state machine, geo validations, evidence uploads, offline sync endpoints, timeline tracking.
   - **Technician performance tracking:** Daily/monthly statistics, earnings calculation, tips management.
   - Admin review actions, audit logging, reporting seeds.
6. **Phase 5 – Ratings & Tips System (Week 11)**
   - Customer rating interface (5-star with sub-scores: quality, punctuality, professionalism, cleanliness).
   - Rating submission API with Arabic/English review text support.
   - Tip payment integration (predefined amounts + custom, processed via Tap).
   - Real-time rating aggregation and technician summary updates.
   - Technician rating history and analytics dashboard.
   - Badge/achievement system based on performance metrics.
7. **Phase 6 – Chat System (Week 12)**
   - Chat threads, messaging APIs, WebSocket integration, typing/read receipts, moderation tools.
8. **Phase 7 – Store & Dedications (Weeks 13-14)**
   - Product catalog, cart, checkout integration, order management.
   - Dedication flows with notifications and optional payment.
9. **Phase 8 – Polishing & Launch (Weeks 15-16)**
   - Harden security, complete documentation & OpenAPI spec, load testing, staging sign-off, deployment automation, monitoring dashboards.
   - Final Arabic localization review and RTL testing.
   - Technician performance report generation for admin.

## 12. External Integrations & Setup Requirements

### Confirmed Integrations
- **Payment Gateway (Primary):** Tap Payments (tap.company)
  - Register merchant account with KSA business documents (CR)
  - Obtain API keys (secret_key, public_key, merchant_id, webhook_secret)
  - Configure webhook URL: `https://yourdomain.com/api/webhooks/tap`
  - Enable Visa, Mastercard, Mada in dashboard
  - For Apple Pay: Register merchant ID in Apple Developer Portal, upload certificate to Tap dashboard
  - Test with sandbox first: `sk_test_xxx`, `pk_test_xxx`

- **Payment Gateway (BNPL):** Tabby (tabby.ai)
  - Apply for merchant account with business registration
  - Submit KYC documents and integration use case
  - Obtain API credentials (secret_key, public_key, merchant_code)
  - Configure webhook: `https://yourdomain.com/api/webhooks/tabby`
  - Test in sandbox environment first

- **Apple Pay Setup:**
  - Apple Developer Account ($99/year)
  - Create Merchant ID: `merchant.com.yourcompany.sudz`
  - Generate Payment Processing Certificate
  - Upload certificate to Tap dashboard
  - Domain verification (handled by Tap for API integrations)

### Additional Integrations Needed
- **OTP Provider:** Twilio, Infobip, or local KSA SMS gateway – confirm pricing and delivery SLA
- **Push Notifications:** Firebase Cloud Messaging (FCM) for Android + Apple Push Notification Service (APNs) for iOS
- **Maps:** Google Maps API for technician navigation and service area validation
- **Email Service:** AWS SES or SendGrid for transactional emails (booking confirmations, receipts, password resets)
- **WebSocket Hosting:** Choose between self-hosted Laravel WebSockets or managed Pusher (consider cost vs control tradeoff)

## 13. Deliverables
- Source-controlled Laravel project with modular architecture and automated tests.
- Comprehensive migrations, seeders, and environment bootstrapping scripts.
- API documentation (OpenAPI), ERD diagrams, admin user guide, incident response playbook.
- Deployment pipeline scripts, infrastructure-as-code templates (Terraform/CloudFormation optional).
- Monitoring dashboards, alert policies, and operational checklists.

## 14. Success Criteria
- 99.5% uptime target with monitored SLIs (booking success rate, payment success rate, chat message delivery latency)
- Payment success rate >95% for card transactions, >90% for Tabby (due to credit approvals)
- Webhook processing latency <5 seconds from gateway event to booking status update
- Transactional integrity for payments and package balances with zero double-charge incidents
- All refunds processed within 5-7 business days (per gateway SLA)
- Real-time chat responsive under peak load (<2s delivery)
- Technician evidence compliance enforced (cannot transition without required photos)
- Apple Pay transactions complete in <10 seconds end-to-end
- Tabby installment capture rate >85% (industry standard)
- Payment reconciliation job detects and alerts on discrepancies within 1 hour
- Positive security review (OWASP API Top 10 mitigations, PCI-DSS via gateway compliance)
- Comprehensive audit logging for all payment state changes and admin actions

