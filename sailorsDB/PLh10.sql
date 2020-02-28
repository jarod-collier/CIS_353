-- File: PLh10.sql
-- Author: Jarod Collier 
-- ----------------------------------
SET SERVEROUTPUT ON
SET VERIFY OFF
-- ----------------------------------
ACCEPT traineeID NUMBER PROMPT 'Enter a trainee ID: '
ACCEPT inc NUMBER PROMPT 'Enter an increment for his trainers rating: '
DECLARE
   sr     sailors%ROWTYPE;

   CURSOR tCursor IS
      SELECT s.sid, s.sname, s.rating, s.age, s.trainee
      FROM Sailors s
      WHERE  s.trainee = '&traineeID';
BEGIN
   OPEN tCursor;
   LOOP
      -- Fetch the qualifying rows one by one
      FETCH tCursor INTO sr;
	  EXIT WHEN tCursor%NOTFOUND;
      -- Print the sailor' old record
      DBMS_OUTPUT.PUT_LINE ('+++ old row: '||sr.sid||'  '
        ||sr.sname||sr.rating||'  '||sr.age||'  '||sr.trainee);
      -- Increment the trainers' rating
      sr.rating := sr.rating + &inc;
	  UPDATE sailors
	  SET rating = sr.rating
      WHERE sailors.sid = sr.sid;
      -- Print the sailor' new record
      DBMS_OUTPUT.PUT_LINE ('+++++ new row: '||sr.sid||'  '
        ||sr.sname||sr.rating||'  '||sr.age||'  '||sr.trainee);
   END LOOP;
   COMMIT;
   -- test whether the sailor has no trainers (Hint: test tCursor%ROWCOUNT)
   IF tCursor%ROWCOUNT < 1
   THEN
    DBMS_OUTPUT.PUT_LINE('+++++ '|| '&traineeID' ||' is either not a sailor, or 
	has no trainer');
   ELSE
    DBMS_OUTPUT.PUT_LINE
    ('+++++ DB has been updated');
   END IF;
   CLOSE tCursor;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('+++++'||SQLCODE||'...'||SQLERRM);
END;
/
-- Let's see what happened to the database
SELECT *
FROM   sailors S
WHERE  S.trainee = '&traineeID';
UNDEFINE traineeID
UNDEFINE inc
