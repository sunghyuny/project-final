from django.urls import path
from .views import package, create_package, package_detail, reservation_page, submit_reservation, reservation_complete, Reservation

urlpatterns = [
    path('', package, name='package'),
    path('create_package/', create_package, name='create_package'),
    path('detail/<int:package_id>/', package_detail, name='package_detail'),
    path('<int:package_id>/reservation/', reservation_page, name='reservation_page'),
    path('<int:package_id>/submit_reservation/', submit_reservation, name='submit_reservation'),  # 추가된 부분
    path('reservation_complete/', reservation_complete, name='reservation_complete'),
]