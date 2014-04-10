
DELETE si
  FROM station_interfaces si
INNER JOIN stations s ON s.id = si.station_id
INNER JOIN seaframes sf ON sf.id = s.seaframe_id
WHERE sf.hull_number > 4;

INSERT INTO station_interfaces
( id,  icd_interface_type_id, name, location, created, modified, station_id, deleted, last_user_id)
SELECT DISTINCT uuid(), si2.icd_interface_type_id, si2.name, si2.location, si2.created, si2.modified,
      st.id, si2.deleted, si2.last_user_id
  FROM seaframes s
INNER JOIN seaframe_contractors sc ON s.seaframe_contractor_id = sc.id
INNER JOIN seaframes s2 ON s2.seaframe_contractor_id = sc.id
INNER JOIN stations st2 ON s2.id = st2.seaframe_id
INNER JOIN station_interfaces si2 ON si2.station_id = st2.id
INNER JOIN stations st ON st.seaframe_id = s.id
                      AND st.icd_station_number  = st2.icd_station_number
WHERE s2.hull_number = 1 and s.hull_number > 4
ORDER BY s.hull_number, s2.hull_number;

INSERT INTO station_interfaces
( id,  icd_interface_type_id, name, location, created, modified, station_id, deleted, last_user_id)
SELECT DISTINCT uuid(), si2.icd_interface_type_id, si2.name, si2.location, si2.created, si2.modified,
      st.id, si2.deleted, si2.last_user_id
  FROM seaframes s
INNER JOIN seaframe_contractors sc ON s.seaframe_contractor_id = sc.id
INNER JOIN seaframes s2 ON s2.seaframe_contractor_id = sc.id
INNER JOIN stations st2 ON s2.id = st2.seaframe_id
INNER JOIN station_interfaces si2 ON si2.station_id = st2.id
INNER JOIN stations st ON st.seaframe_id = s.id
                      AND st.icd_station_number  = st2.icd_station_number
WHERE s2.hull_number = 2 and s.hull_number > 4
ORDER BY s.hull_number, s2.hull_number;


-- run final      5      22      Sea Operating Station  28VDC 10A 0.28kW        2


SELECT  'run pre-final' as iteration, s.hull_number,
        st.name as station_name,
        stt.name as station_type_name,
        iit.station_interface_type_name,
            count(*)
  FROM      station_interfaces  si
INNER JOIN icd_interface_types iit    ON iit.id = si.icd_interface_type_id
INNER JOIN stations            st    ON st.id  = si.station_id
INNER JOIN sf_station_types    stt    ON stt.id = st.sf_station_type_id
                                      AND stt.seaframe_id = st.seaframe_id
INNER JOIN seaframes            s    ON s.id  = st.seaframe_id
                                      AND s.id = st.seaframe_id
WHERE s.hull_number IN (1,3,5)
GROUP BY iteration, stt.name, st.name, iit.station_interface_type_name, s.hull_number
HAVING count(*) > 1
ORDER BY stt.name, st.name, iit.station_interface_type_name, s.hull_number;

INSERT INTO station_interfaces
       (id, icd_interface_type_id, sf_interface_type_id, station_id, deleted, created, last_user_id, modified)
SELECT DISTINCT uuid(), iit.id, sfit.id, st.id, 0, now(), NULL, NULL
      FROM sf_station_types_sf_interface_types sfstsfit
INNER JOIN seaframes sf                             ON   sf.id = sfstsfit.seaframe_id
INNER JOIN sf_station_types sfst                    ON sfst.id = sfstsfit.sf_station_type_id
                                                   AND   sf.id =     sfst.seaframe_id
INNER JOIN sf_interface_types sfit                  ON sfit.id = sfstsfit.sf_interface_type_id
                                                   AND   sf.id =     sfit.seaframe_id
INNER JOIN icd_interface_types iit                  ON  iit.id =     sfit.icd_interface_type_id
INNER JOIN stations st                              ON sfst.id =       st.sf_station_type_id
                                                   AND   sf.id =       st.seaframe_id
 LEFT JOIN station_interfaces si                    ON   st.id =       si.station_id
                                                   AND  iit.id =       si.icd_interface_type_id
WHERE si.id IS NULL
GROUP BY sfit.icd_interface_type_id, sfit.id, st.id
ORDER BY sf.hull_number, st.name, sfit.station_interface_type_name;

SELECT  'run final' as iteration, s.hull_number,
        st.name as station_name,
        stt.name as station_type_name,
        iit.station_interface_type_name,
            count(*)
  FROM      station_interfaces  si
INNER JOIN icd_interface_types iit    ON iit.id = si.icd_interface_type_id
INNER JOIN stations            st    ON st.id  = si.station_id
INNER JOIN sf_station_types    stt    ON stt.id = st.sf_station_type_id
                                      AND stt.seaframe_id = st.seaframe_id
INNER JOIN seaframes            s    ON s.id  = st.seaframe_id
                                      AND s.id = st.seaframe_id
WHERE s.hull_number IN (1,3,5)
GROUP BY iteration, stt.name, st.name, iit.station_interface_type_name, s.hull_number
HAVING count(*) > 1
ORDER BY stt.name, st.name, iit.station_interface_type_name, s.hull_number;


