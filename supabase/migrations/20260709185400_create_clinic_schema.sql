/*
# Physiotherapy / Chiropractic Clinic Schema

## Overview
Initial database schema for a medical clinic website that offers physiotherapy,
chiropractic, acupuncture, and related services. No sign-in required (single-tenant,
public-facing site). All tables use anon + authenticated RLS policies so the
frontend can read and write via the anon key.

## New Tables

### services
Clinic services offered (chiropractic, acupuncture, electrotherapy, etc.).
- id: UUID primary key
- name: Service display name
- slug: URL-friendly identifier
- description: Full description of the service
- icon: Flaticon icon name (matches the existing flaticon set)
- image_url: Optional hero image URL
- order_index: Controls display order
- is_active: Whether the service is currently offered
- created_at / updated_at: Timestamps

### staff
Practitioners and doctors at the clinic.
- id: UUID primary key
- name: Full name
- title: Professional title (e.g., "Dr.", "PT")
- specialty: Area of expertise
- bio: Biographical description
- image_url: Profile photo URL
- order_index: Controls display order
- is_active: Whether staff member is currently listed
- created_at / updated_at: Timestamps

### appointments
Patient appointment bookings submitted via the website.
- id: UUID primary key
- patient_name: Full name of the patient
- patient_email: Contact email
- patient_phone: Contact phone
- service_id: FK to services (nullable, patient may not know exact service)
- preferred_date: Requested appointment date
- preferred_time: Requested appointment time (text, e.g. "10:00 AM")
- message: Additional notes from the patient
- status: Booking status (pending, confirmed, cancelled)
- created_at / updated_at: Timestamps

### testimonials
Patient reviews and testimonials displayed on the site.
- id: UUID primary key
- patient_name: Name (can be anonymized, e.g. "John D.")
- rating: Star rating 1–5
- review: Testimonial text
- service_id: FK to services (optional)
- is_featured: Whether shown on homepage
- is_active: Whether published
- created_at: Timestamp

### contact_messages
Submissions from the site contact form.
- id: UUID primary key
- name: Sender's name
- email: Sender's email
- phone: Optional phone number
- subject: Message subject
- message: Full message body
- is_read: Whether an admin has read it
- created_at: Timestamp

## Security
- RLS enabled on all tables.
- Public (anon + authenticated) SELECT on services, staff, testimonials.
- Public (anon + authenticated) INSERT on appointments and contact_messages (form submissions).
- No public UPDATE/DELETE on appointments or contact_messages (admin only via service role).
- No public INSERT on services, staff, testimonials (managed via service role / admin).
*/

-- ─────────────────────────────────────────────
-- SERVICES
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS services (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  slug        text NOT NULL UNIQUE,
  description text,
  icon        text,
  image_url   text,
  order_index integer NOT NULL DEFAULT 0,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_select_services" ON services;
CREATE POLICY "public_select_services" ON services FOR SELECT
  TO anon, authenticated USING (true);

-- ─────────────────────────────────────────────
-- STAFF
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS staff (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  title       text,
  specialty   text,
  bio         text,
  image_url   text,
  order_index integer NOT NULL DEFAULT 0,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);

ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_select_staff" ON staff;
CREATE POLICY "public_select_staff" ON staff FOR SELECT
  TO anon, authenticated USING (true);

-- ─────────────────────────────────────────────
-- APPOINTMENTS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS appointments (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_name   text NOT NULL,
  patient_email  text NOT NULL,
  patient_phone  text,
  service_id     uuid REFERENCES services(id) ON DELETE SET NULL,
  preferred_date date NOT NULL,
  preferred_time text NOT NULL,
  message        text,
  status         text NOT NULL DEFAULT 'pending'
                   CHECK (status IN ('pending', 'confirmed', 'cancelled')),
  created_at     timestamptz DEFAULT now(),
  updated_at     timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_appointments_service_id   ON appointments(service_id);
CREATE INDEX IF NOT EXISTS idx_appointments_preferred_date ON appointments(preferred_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status        ON appointments(status);

ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_insert_appointments" ON appointments;
CREATE POLICY "public_insert_appointments" ON appointments FOR INSERT
  TO anon, authenticated WITH CHECK (true);

-- ─────────────────────────────────────────────
-- TESTIMONIALS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS testimonials (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_name text NOT NULL,
  rating       smallint NOT NULL DEFAULT 5
                 CHECK (rating BETWEEN 1 AND 5),
  review       text NOT NULL,
  service_id   uuid REFERENCES services(id) ON DELETE SET NULL,
  is_featured  boolean NOT NULL DEFAULT false,
  is_active    boolean NOT NULL DEFAULT true,
  created_at   timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_testimonials_service_id  ON testimonials(service_id);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_featured ON testimonials(is_featured);

ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_select_testimonials" ON testimonials;
CREATE POLICY "public_select_testimonials" ON testimonials FOR SELECT
  TO anon, authenticated USING (is_active = true);

-- ─────────────────────────────────────────────
-- CONTACT MESSAGES
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS contact_messages (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text NOT NULL,
  email      text NOT NULL,
  phone      text,
  subject    text,
  message    text NOT NULL,
  is_read    boolean NOT NULL DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_insert_contact_messages" ON contact_messages;
CREATE POLICY "public_insert_contact_messages" ON contact_messages FOR INSERT
  TO anon, authenticated WITH CHECK (true);
