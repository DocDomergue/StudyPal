from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-+!)td_+uxkfzt=d0m3t8d#pcr8-blpp^3-*@a#c!k37s(b@09n'
# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

ALLOWED_HOSTS = ["one.ehinchli.w3.uvm.edu", ".uvm.edu", "uvm.edu"]

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django_cas_ng',
    'ninja',
    'courses',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django_cas_ng.middleware.CASMiddleware',
]

ROOT_URLCONF = 'serverapi.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'serverapi.wsgi.application'

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "EHINCHLI_labs",
        "USER": "ehinchli_admin",
        "PASSWORD": "GuKzuI5WXAUT",
        "HOST": "webdb.uvm.edu",
        "OPTIONS": {"charset": "utf8mb4"},
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]
AUTHENTICATION_BACKENDS = ["django.contrib.auth.backends.ModelBackend",
                           "django_cas_ng.backends.CASBackend"]

# CAS AUTHENTICATION - https://djangocas.dev/docs
CAS_SERVER_URL = "https://idp.uvm.edu/idp/profile/cas/login"
CAS_VERSION = "2"
CAS_ADMIN_PREFIX = None
CAS_REDIRECT_URL = f"https://one.ehinchli.w3.uvm.edu/"
CAS_ROOT_PROXIED_AS = f"https://one.ehinchli.w3.uvm.edu/"

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

STATIC_ROOT = BASE_DIR / "public/static"
STATIC_URL = "/static/"
STATICFILES_DIRS = [BASE_DIR / "static"]
STATICFILES_FINDERS = (
    "django.contrib.staticfiles.finders.FileSystemFinder",
    "django.contrib.staticfiles.finders.AppDirectoriesFinder",
)

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

CSRF_TRUSTED_ORIGINS = [
    "https://www.uvm.edu",
    "https://one.ehinchli.w3.uvm.edu/*",
    "https://www.uvm.edu",
]
