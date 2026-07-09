ALTER TABLE services DISABLE ROW LEVEL SECURITY;
ALTER TABLE staff DISABLE ROW LEVEL SECURITY;
ALTER TABLE appointments DISABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials DISABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages DISABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts DISABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_select_services" ON services;
DROP POLICY IF EXISTS "public_insert_services" ON services;
DROP POLICY IF EXISTS "public_update_services" ON services;
DROP POLICY IF EXISTS "public_delete_services" ON services;

DROP POLICY IF EXISTS "public_select_staff" ON staff;
DROP POLICY IF EXISTS "public_insert_staff" ON staff;
DROP POLICY IF EXISTS "public_update_staff" ON staff;
DROP POLICY IF EXISTS "public_delete_staff" ON staff;

DROP POLICY IF EXISTS "public_select_appointments" ON appointments;
DROP POLICY IF EXISTS "public_insert_appointments" ON appointments;
DROP POLICY IF EXISTS "public_update_appointments" ON appointments;
DROP POLICY IF EXISTS "public_delete_appointments" ON appointments;

DROP POLICY IF EXISTS "public_select_testimonials" ON testimonials;
DROP POLICY IF EXISTS "public_insert_testimonials" ON testimonials;
DROP POLICY IF EXISTS "public_update_testimonials" ON testimonials;
DROP POLICY IF EXISTS "public_delete_testimonials" ON testimonials;

DROP POLICY IF EXISTS "public_select_contact_messages" ON contact_messages;
DROP POLICY IF EXISTS "public_insert_contact_messages" ON contact_messages;
DROP POLICY IF EXISTS "public_update_contact_messages" ON contact_messages;
DROP POLICY IF EXISTS "public_delete_contact_messages" ON contact_messages;

DROP POLICY IF EXISTS "public_select_blog_posts" ON blog_posts;
DROP POLICY IF EXISTS "public_insert_blog_posts" ON blog_posts;
DROP POLICY IF EXISTS "public_update_blog_posts" ON blog_posts;
DROP POLICY IF EXISTS "public_delete_blog_posts" ON blog_posts;
