from django.contrib.auth import get_user_model
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models

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



