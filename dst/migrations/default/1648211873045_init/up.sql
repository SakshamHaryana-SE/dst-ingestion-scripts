SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.attendance (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    industry_id integer NOT NULL,
    trainee_id integer NOT NULL,
    date date NOT NULL,
    is_present boolean NOT NULL
);
CREATE SEQUENCE public.attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.attendance_id_seq OWNED BY public.attendance.id;
CREATE TABLE public.industry (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text,
    latitude real NOT NULL,
    longitude real NOT NULL
);
CREATE SEQUENCE public.industry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.industry_id_seq OWNED BY public.industry.id;
CREATE TABLE public.iti (
    id integer NOT NULL,
    latitude real NOT NULL,
    longitude real NOT NULL,
    name text
);
CREATE SEQUENCE public.iti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.iti_id_seq OWNED BY public.iti.id;
CREATE TABLE public.quml_response (
    body text,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);
CREATE TABLE public.schedule (
    id integer NOT NULL,
    batch_start integer NOT NULL,
    batch_end integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    is_industry boolean NOT NULL,
    industry_id integer NOT NULL
);
CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;
CREATE TABLE public.trainee (
    id integer NOT NULL,
    iti integer NOT NULL,
    name text,
    batch text,
    "affiliationType" text,
    "registrationNumber" text,
    "DOB" date,
    "tradeName" text,
    industry integer NOT NULL,
    father text,
    mother text,
    gender text,
    "dateOfAdmission" date
);
CREATE SEQUENCE public.trainee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.trainee_id_seq OWNED BY public.trainee.id;
ALTER TABLE ONLY public.attendance ALTER COLUMN id SET DEFAULT nextval('public.attendance_id_seq'::regclass);
ALTER TABLE ONLY public.industry ALTER COLUMN id SET DEFAULT nextval('public.industry_id_seq'::regclass);
ALTER TABLE ONLY public.iti ALTER COLUMN id SET DEFAULT nextval('public.iti_id_seq'::regclass);
ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);
ALTER TABLE ONLY public.trainee ALTER COLUMN id SET DEFAULT nextval('public.trainee_id_seq'::regclass);
ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.industry
    ADD CONSTRAINT industry_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.iti
    ADD CONSTRAINT iti_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.quml_response
    ADD CONSTRAINT quml_response_id_key UNIQUE (id);
ALTER TABLE ONLY public.quml_response
    ADD CONSTRAINT quml_response_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.trainee
    ADD CONSTRAINT trainee_pkey PRIMARY KEY (id);
CREATE TRIGGER set_public_attendance_updated_at BEFORE UPDATE ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_attendance_updated_at ON public.attendance IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_industry_updated_at BEFORE UPDATE ON public.industry FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_industry_updated_at ON public.industry IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_industry_id_fkey FOREIGN KEY (industry_id) REFERENCES public.industry(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_trainee_id_fkey FOREIGN KEY (trainee_id) REFERENCES public.trainee(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_industry_id_fkey FOREIGN KEY (industry_id) REFERENCES public.industry(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.trainee
    ADD CONSTRAINT trainee_industry_fkey FOREIGN KEY (industry) REFERENCES public.industry(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.trainee
    ADD CONSTRAINT trainee_iti_fkey FOREIGN KEY (iti) REFERENCES public.iti(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
