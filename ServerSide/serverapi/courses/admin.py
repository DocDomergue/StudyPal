from django.contrib import admin

# Register your models here.
from .models import Course, UserProfile


@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    ordering = ["title"]


@admin.register(UserProfile)
class ProfileAdmin(admin.ModelAdmin):
    ordering = ["user"]
