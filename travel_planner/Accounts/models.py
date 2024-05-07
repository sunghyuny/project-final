from django.contrib.auth import get_user_model
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models
from travel_planner import settings


class CustomUser(AbstractUser):
    age = models.IntegerField(null=True, blank=True)
    email = models.EmailField(unique=True)
    mbti = models.CharField(max_length=4)
    gender_choices = [
        ('male', '남자'),
        ('female', '여자')
    ]
    gender = models.CharField(max_length=10, choices=gender_choices)
    groups = models.ManyToManyField(Group, related_name='customuser_groups')
    user_permissions = models.ManyToManyField(Permission, related_name='customuser_user_permissions')
    trip_plans = models.ManyToManyField('planner.TripPlan', related_name='users_trip_plans')


class Like(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='likes')
    trip_plan = models.ForeignKey('planner.TripPlan', on_delete=models.CASCADE, related_name='liked_by')

    class Meta:
        # 한 사용자가 같은 여행 계획에 대해 여러 번 좋아요를 할 수 없도록 유니크 제약 조건을 설정합니다.
        unique_together = ('user', 'trip_plan')

    def __str__(self):
        return f"{self.user.username} likes {self.trip_plan.title}"

