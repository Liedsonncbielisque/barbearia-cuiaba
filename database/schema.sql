CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  price_cents integer NOT NULL CHECK (price_cents >= 0),
  duration_minutes integer NOT NULL CHECK (duration_minutes > 0),
  requires_evaluation boolean NOT NULL DEFAULT false,
  active boolean NOT NULL DEFAULT true
);

CREATE TABLE customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  phone text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES customers(id),
  service_id uuid NOT NULL REFERENCES services(id),
  starts_at timestamptz NOT NULL,
  status text NOT NULL DEFAULT 'requested' CHECK (status IN ('requested','confirmed','cancelled','completed')),
  notes text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX bookings_starts_at_idx ON bookings(starts_at);
CREATE INDEX bookings_status_idx ON bookings(status);

INSERT INTO services(name, price_cents, duration_minutes, requires_evaluation) VALUES
('Corte',3500,45,false),
('Barba',2000,30,false),
('Combo',5500,75,false),
('Química e colorometria',0,60,true);