-- Self join

-- 1. How many stops are in the database
SELECT COUNT(id) FROM stops;

-- 2. Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops
  WHERE name='Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name
  FROM stops JOIN route ON id=stop
  WHERE num='4' AND company='LRT';

-- 4. The query shown gives the number of routes that visit either London Road (149) 
--    or Craiglockhart (53)
SELECT company, num, COUNT(*)
  FROM route 
  WHERE stop=149 OR stop=53
  GROUP BY company, num
  HAVING COUNT(*)=2;

-- 5. Change the query so that it shows the services from Craiglockhart to London Road
SELECT a.company, a.num, a.stop, b.stop
  FROM route a JOIN route b ON a.company=b.company AND a.num=b.num
  WHERE a.stop=53 AND b.stop=(SELECT stop
    FROM stops JOIN route ON id=stop
    WHERE name='London Road' LIMIT 1);

-- 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown
SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a JOIN route b ON a.company=b.company AND a.num=b.num
    JOIN stops stopa ON a.stop=stopa.id
    JOIN stops stopb ON b.stop=stopb.id
  WHERE stopa.name='Craiglockhart' AND stopb.name='London Road';

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT R1.company, R1.num
  FROM route R1, route R2
  WHERE R1.num=R2.num AND R1.company=R2.company
    AND R1.stop=115 AND R2.stop=137;

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT R1.company, R1.num
  FROM route R1, route R2, stops S1, stops S2
  WHERE R1.num=R2.num AND R1.company=R2.company
    AND R1.stop=S1.id AND R2.stop=S2.id
    AND S1.name='Craiglockhart'
    AND S2.name='Tollcross';

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
--    including 'Craiglockhart' itself. Include the company and bus no. of the relevant services
SELECT S1.name, R1.company, R1.num
  FROM route R1, route R2, stops S1, stops S2
  WHERE R1.num=R2.num AND R1.company=R2.company
    AND R1.stop=S1.id AND R2.stop=S2.id
    AND S2.name='Craiglockhart';

-- 10. Find the routes involving two buses that can go from Craiglockhart to Sighthill. Show the bus no. and 
--     company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus
SELECT DISTINCT bus1.num, bus1.company, name, bus2.num, bus2.company 
  FROM (SELECT start1.num, start1.company, stop1.stop 
    FROM route AS start1 JOIN route AS stop1 ON start1.num = stop1.num 
      AND start1.company = stop1.company AND start1.stop != stop1.stop 
  WHERE start1.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')) AS bus1 
    JOIN (SELECT start2.num, start2.company, start2.stop FROM route AS start2 
      JOIN route AS stop2 ON start2.num = stop2.num 
      AND start2.company = stop2.company and start2.stop != stop2.stop 
      WHERE stop2.stop = (SELECT id FROM stops WHERE name = 'Sighthill')) AS bus2 
    ON bus1.stop = bus2.stop JOIN stops ON bus1.stop = stops.id;