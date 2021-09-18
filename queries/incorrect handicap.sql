select GolfCourseName, MensHandicapTotal=sum(h.HandicapMen), WomensHandicapTotal=sum(h.HandicapWomen)
from GolfCourseHoles H
 inner join GolfCourses c on c.GolfCourseID=h.GolfCourseID
group by GolfCourseName
having sum(h.HandicapMen)<> 171 or sum(h.HandicapWomen)<> 171