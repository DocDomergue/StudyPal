from typing import List

from django.contrib.auth import authenticate, login
from django.db.models import Q
from django.shortcuts import get_object_or_404
from ninja import NinjaAPI, Schema, Form, Schema, Router
from ninja.security import django_auth

from .models import UserProfile, Course, User

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


@api.get("/add_course/", auth=django_auth)
def add_course_to_user(request, course_id):
    user_profile = get_object_or_404(UserProfile, user_id=request.auth.id)
    course = get_object_or_404(Course, id=course_id)
    user_profile.courses.add(course)

    return api.create_response(request, data={"success": "Course added successfully."}, status=200)


@api.get("/remove_course/", auth=django_auth)
def remove_course_to_user(request, course_id):
    user_profile = get_object_or_404(UserProfile, user_id=request.auth.id)
    course = get_object_or_404(Course, id=course_id)
    user_profile.courses.remove(course)

    return api.create_response(request, data={"success": "Course removed successfully."}, status=200)


@api.get("/list_courses/", auth=django_auth, response=List[CourseSchema])
def list_courses(request):
    user_profile = get_object_or_404(UserProfile, user_id=request.auth.id)
    
    return user_profile.courses.all()
