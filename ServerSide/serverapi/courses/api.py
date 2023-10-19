from django.db.models import Q
from ninja import Router

from .models import Course

router = Router()


@router.get("/search/")
def search_courses(request, query: str):
    # Construct the Q objects for each column
    queries = [
        Q(subj__icontains=query),
        Q(course_number__icontains=query),
        Q(title__icontains=query),
        Q(comp_numb__icontains=query),
        Q(section__icontains=query),
        Q(ptrm__icontains=query),
        Q(lec_lab__icontains=query),
        Q(attr__icontains=query),
        Q(camp_code__icontains=query),
        Q(coll_code__icontains=query),
        Q(max_enrollment__icontains=query),
        Q(current_enrollment__icontains=query),
        Q(true_max__icontains=query),
        Q(start_time__icontains=query),
        Q(end_time__icontains=query),
        Q(days__icontains=query),
        Q(credits__icontains=query),
        Q(bldg__icontains=query),
        Q(room__icontains=query),
        Q(gp_ind__icontains=query),
        Q(instructor__icontains=query),
        Q(netid__icontains=query),
        Q(email__icontains=query),
        Q(fees__icontains=query),
        Q(xlistings__icontains=query),
    ]

    # Combine the Q objects using the OR operator
    combined_query = queries.pop()
    for item in queries:
        combined_query |= item

    # Filter the courses using the combined query
    courses = Course.objects.filter(combined_query)
    return {"results": [
        {"id": course.id, "title": course.title, "subj": course.subj, "course_number": course.course_number,
         "section": course.section, "instructor": course.instructor, "start_time": course.start_time,
         "end_time": course.end_time, "days": course.days, "bldg": course.bldg, "room": course.room,
         "credits": course.credits, "fees": course.fees, "xlistings": course.xlistings, "ptrm": course.ptrm,
         "lec_lab": course.lec_lab, "attr": course.attr, "camp_code": course.camp_code, "coll_code": course.coll_code,
         "max_enrollment": course.max_enrollment, "current_enrollment": course.current_enrollment,
         "true_max": course.true_max, "gp_ind": course.gp_ind, "netid": course.netid, "email": course.email,
         "comp_numb": course.comp_numb}
        for course in courses]}
