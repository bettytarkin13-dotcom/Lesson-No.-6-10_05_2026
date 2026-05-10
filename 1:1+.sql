--1.Create a patients table with: patient_id (PK AUTOINCREMENT), patient_name, blood_type.--

DROP TABLE IF EXISTS patients;
CREATE TABLE patients (
       patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
	   patient_name TEXT NOT NULL,
	   blood_type TEXT
);

--2.Create a medical_files table with: file_id (PK AUTOINCREMENT), patient_ref (UNIQUE FK to patients(patient_id)), allergies, emergency_contact.--

CREATE TABLE medical_files(
       file_id INTEGER PRIMARY KEY AUTOINCREMENT,
	   patient_ref INTEGER UNIQUE NOT NULL,
	   allergies TEXT,
	   emergency_contact TEXT,
	   FOREIGN KEY (patient_ref) REFERENCES patients (patient_id) ON DELETE CASCADE
);

--3.Insert 3 patients: Dr. Aisha Khan (O+), Marcus Williams (AB-), Dr. Priya Singh (B+)--

INSERT INTO patients (patient_name,blood_type) VALUES
('Dr. Aisha Khan','O+'),
('Marcus Williams','AB-'),
('Dr. Priya Singh','B+');

--4.Insert 2 medical files: Aisha (allergies: Penicillin, contact: +1-555-0101) and Marcus (allergies: None, contact: +1-555-0202). Leave Priya without a file.--

INSERT INTO medical_files (patient_ref,allergies,emergency_contact) VALUES
(1,'Penicillin','+1-555-0101'),
(2,'None','+1-555-0202');

--5.Write a LEFT JOIN query to list all patients and their file data — displaying 'No medical history' for those without a file.

SELECT
  p.patient_id,
  p.patient_name,
  p.blood_type,
  COALESCE (m.allergies,'No medical history') AS allergies,
  m.emergency_contact
FROM patients p 
LEFT JOIN medical_files m ON m.patient_ref = p.patient_id;

--6.Try adding a second file for the same patient_ref. Explain the error.--
	
INSERT INTO medical_files (patient_ref,allergies,emergency_contact) VALUES
(1,'Penicillin','+1-555-0303');

-- You get an error because patient_ref is defined as UNIQUE in the medical_files table.
-- That means each patient_id can appear only once in the table.--

--7.Delete a patient (who has a medical file). Then query the medical_files table. What happened to their file? Why?--

DELETE FROM patients
WHERE patient_id = 1;

SELECT * FROM madical_files ;
--The row in medical_files (for that patient) is also automatically deleted.
--So the file linked to patient_id = 1 disappears from the table.--
