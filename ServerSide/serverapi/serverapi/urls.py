from django.contrib import admin
from django.urls import path, include
from ninja import NinjaAPI
from courses.api import router as courses_router

api = NinjaAPI()
api.add_router('courses', courses_router)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', api.urls),
]
