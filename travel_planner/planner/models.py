from django.db import models
from thesights.models import *
from hotel.models import *
class ActivityCategory(models.Model):
    name = models.TextField()
    quantity = models.IntegerField(default=0)

class Activity(models.Model):
    name = models.TextField()
    price = models.TextField()
    photo = models.ImageField(upload_to='activity_photo/')
    location = models.TextField()
    telephone = models.TextField()
    time = models.TextField()
    category = models.ForeignKey(ActivityCategory, on_delete=models.CASCADE)

class TripPlan(models.Model):
    arrival_date = models.DateField()
    total_people = models.IntegerField()
    selected_accommodation = models.ForeignKey(Accommodation, on_delete=models.CASCADE, null=True, blank=True)
    selected_activity = models.ForeignKey(Activity, on_delete=models.CASCADE, null=True, blank=True)

    # 기타 필드들
    departure_date = models.DateField()
    destination = models.CharField(max_length=100)
    transportation_method = models.CharField(max_length=100)

    def __str__(self):
        return f"Trip Plan: {self.arrival_date}"

    def calculate_duration(self):
        # 도착일과 출발일로 여행 기간 계산
        if self.departure_date and self.arrival_date:
            duration = (self.departure_date - self.arrival_date).days
            return duration
        return None

    def total_cost(self):
        # 선택된 숙소와 활동의 가격을 합산하여 총 여행 비용 계산
        total_cost = 0
        if self.selected_accommodation:
            total_cost += self.selected_accommodation.price
        if self.selected_activity:
            total_cost += self.selected_activity.price
        return total_cost
# Create your models here.
class Accommodation(models.Model):
    name = models.CharField(max_length=100)
    # 다른 필드들 추가


class TripPlan(models.Model):
    arrival_date = models.DateField()
    total_people = models.IntegerField()

