from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect
from django.urls import reverse


def index(request):
    if not request.user.is_authenticated:
        return redirect(reverse("cas_ng_login"))
    return HttpResponse(f"Logged in as {request.user}")
