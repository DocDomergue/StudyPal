import django_cas_ng.views
from profiles.api import api
from django.conf.urls.static import static
from serverapi.settings import STATIC_ROOT, STATIC_URL
from django.contrib import admin
from django.urls import path

from profiles import views


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', api.urls),
    path('', views.index),
    path('accounts/login', django_cas_ng.views.LoginView.as_view(), name='cas_ng_login'),
    path('accounts/logout', django_cas_ng.views.LogoutView.as_view(), name='cas_ng_logout'),
    path('accounts/callback', django_cas_ng.views.CallbackView.as_view(), name='cas_ng_proxy_callback'),

]

urlpatterns += static(STATIC_URL, document_root=STATIC_ROOT)