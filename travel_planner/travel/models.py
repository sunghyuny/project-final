from Accounts.models import CustomUser
from django.db import models
from thesights.models import RegionCategory
from hotel.models import Accommodation
from django.conf import settings
from django.contrib.auth.models import User

class Package(models.Model):
    destination = models.CharField(max_length=100)  # 목적지
    start_date = models.DateField()  # 시작 날짜
    end_date = models.DateField()  # 종료 날짜
    adult_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # 성인 가격
    youth_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # 청소년 가격
    child_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # 어린이 가격
    image = models.ImageField(upload_to='package_images/')  # 이미지
    accommodation = models.ForeignKey(Accommodation, on_delete=models.CASCADE, null=True, blank=True)  # 숙소
    accommodation_price = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)  # 숙소 가격
    region_category = models.ForeignKey(RegionCategory, on_delete=models.CASCADE, null=True, blank=True)  # 지역 카테고리

    def __str__(self):
        return f"{self.destination} ({self.start_date} - {self.end_date})"

    @property
    def total_price(self):
        return self.price + self.accommodation_price


class FreeTravel(models.Model):
    destination = models.CharField(max_length=100)
    start_date = models.DateField()
    end_date = models.DateField()

    def __str__(self):
        return f"자유여행: {self.destination} ({self.start_date} - {self.end_date})"


class Traveler(models.Model):
    reservation = models.ForeignKey('Reservation', related_name='travelers', on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=15)


class Reservation(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, null=True, blank=True)
    package = models.ForeignKey('Package', on_delete=models.CASCADE, null=True, blank=True)
    adult_count = models.IntegerField()
    youth_count = models.IntegerField()
    child_count = models.IntegerField()
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'예약 #{self.id} - {self.package.destination if self.package else "자유여행"}'

    def calculate_total_price(self):
        return (
            self.adult_count * self.package.adult_price +
            self.youth_count * self.package.youth_price +
            self.child_count * self.package.child_price +
            self.package.accommodation_price
        ) if self.package else 0