from django.urls import path

from .views import *

urlpatterns = [
    path('', package, name='package'),
    path('create_package/', create_package,name='create_package'),
    path('<int:package_id>/reservation/', reservation_page, name='reservation_page'),
    path('detail/<int:package_id>/', package_detail, name='package_detail')
]