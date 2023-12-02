import json

from django.db.models import Q
from django.http import JsonResponse
from ninja import NinjaAPI, Schema
from ninja.errors import HttpError
from ninja.security import django_auth

from .models import UserProfile, Course

api = NinjaAPI(csrf=True)


class CourseSchema(Schema):
    subj: str
    course_number: str
    title: str
    section: str
    instructor: str
    start_time: str = None
    end_time: str = None
    days: str
    bldg: str
    room: str
    credits: str
    xlistings: str
    lec_lab: str
    coll_code: str
    max_enrollment: int
    current_enrollment: int
    comp_numb: int
    id: int
    email: str


@api.get("/search/")
def search_courses(request, query: str):
    # Construct the Q objects for each column
    queries = [
        Q(subj__icontains=query),
        Q(course_number__icontains=query),
        Q(title__icontains=query),
        Q(comp_numb__icontains=query),
        Q(section__icontains=query),
        Q(lec_lab__icontains=query),
        Q(coll_code__icontains=query),
        Q(instructor__icontains=query),
        Q(netid__icontains=query),
        Q(xlistings__icontains=query),
    ]
    combined_query = queries.pop()
    for item in queries:
        combined_query |= item

    # Filter the courses using the combined query
    courses = Course.objects.filter(combined_query)
    return {"results": [
        {"id": course.id, "title": course.title, "subj": course.subj, "course_number": course.course_number,
         "section": course.section, "instructor": course.instructor, "start_time": course.start_time,
         "end_time": course.end_time, "days": course.days, "bldg": course.bldg, "room": course.room,
         "credits": course.credits, "fees": course.fees, "xlistings": course.xlistings,
         "lec_lab": course.lec_lab, "coll_code": course.coll_code,
         "max_enrollment": course.max_enrollment, "current_enrollment": course.current_enrollment,
         "netid": course.netid, "email": course.email, "comp_numb": course.comp_numb}
        for course in courses]}


@api.get("/userprofile/", auth=django_auth)
def get_user_profile(request):
    try:
        profile = UserProfile.objects.get(user_id=request.auth.id)
        return profile.user_data
    except UserProfile.DoesNotExist:
        raise HttpError(404, message="UserProfile not found")


class UserProfileSchema(Schema):
    user_data: str


@api.post("/userprofile/", response={200: None, 404: None}, auth=django_auth)
def update_user_profile(request):
    try:
        data = json.loads(request.body)
        profile = UserProfile.objects.get(user_id=request.auth.id)
        profile.user_data = data
        profile.save()
        return 200
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)


@api.get("/total_study", auth=django_auth)
def get_total_study_stat(request):
    total = 0
    user_profiles = UserProfile.objects.all()
    for profile in user_profiles:
        total += profile.user_data.get('studyStat', 0)
    return {"total_study": total}

# with open('./log.log', 'w') as file:
#     file.write(total_study_stat)