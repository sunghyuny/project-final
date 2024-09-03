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
    profile_picture = models.ImageField(upload_to='profile_pictures/', null=True, blank=True, default='profile_pictures/default.jpg')  # 기본 프로필 사진 설정
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



class FriendGroup(models.Model):
    owner = models.ForeignKey(
        CustomUser,  # CustomUser 모델을 사용합니다.
        related_name='friend_groups', 
        on_delete=models.CASCADE
    )
    name = models.CharField(max_length=100)
    friends = models.ManyToManyField(CustomUser, related_name='in_groups')  # CustomUser 모델을 사용합니다.

    def __str__(self):
        return f"{self.owner.username}'s group: {self.name}"


class FriendRequest(models.Model):
    from_user = models.ForeignKey(
        CustomUser,  # CustomUser 모델을 사용합니다.
        related_name='from_user', 
        on_delete=models.CASCADE
    )
    to_user = models.ForeignKey(
        CustomUser,  # CustomUser 모델을 사용합니다.
        related_name='to_user', 
        on_delete=models.CASCADE
    )
    trip_plan = models.ForeignKey(
        'planner.TripPlan', on_delete=models.CASCADE, null=True, blank=True
    )  # 여행 계획 참조
    timestamp = models.DateTimeField(auto_now_add=True)
    status = models.CharField(
        max_length=20, 
        choices=[('pending', 'Pending'), ('accepted', 'Accepted'), ('rejected', 'Rejected')], 
        default='pending'
    )
    group = models.ForeignKey(
        FriendGroup, on_delete=models.SET_NULL, null=True, blank=True, related_name='requests'
    )

    def __str__(self):
        return f"Friend request from {self.from_user} to {self.to_user} for plan {self.trip_plan}"

    class Meta:
        unique_together = ('from_user', 'to_user', 'trip_plan')

    def accept(self):
        """친구 요청을 수락하고 Friend 관계를 생성하고, 선택된 그룹에 친구를 추가합니다."""
        self.status = 'accepted'
        self.save()
        Friend.make_friends(self.from_user, self.to_user)
        
        # 그룹이 지정된 경우, 친구를 해당 그룹에 추가
        if self.group:
            self.group.friends.add(self.from_user, self.to_user)
        
        # 친구 요청을 삭제
        self.delete()

    def reject(self):
        """친구 요청을 거절하고 상태를 업데이트합니다."""
        self.status = 'rejected'
        self.save()
        
        # 친구 요청을 삭제
        self.delete()
        
class Friend(models.Model):
    users = models.ManyToManyField(CustomUser, related_name='friends', blank=True)  # CustomUser 모델을 사용합니다.
    current_user = models.ForeignKey(
        CustomUser,  # CustomUser 모델을 사용합니다.
        related_name='owner', 
        null=True, 
        on_delete=models.CASCADE
    )

    @classmethod
    def make_friends(cls, user1, user2):
        """양방향 친구 관계를 생성합니다."""
        friend1, created = cls.objects.get_or_create(current_user=user1)
        friend2, created = cls.objects.get_or_create(current_user=user2)

        friend1.users.add(user2)
        friend2.users.add(user1)

    @classmethod
    def lose_friends(cls, user1, user2):
        """양방향 친구 관계를 제거합니다."""
        try:
            friend1 = cls.objects.get(current_user=user1)
            friend2 = cls.objects.get(current_user=user2)

            friend1.users.remove(user2)
            friend2.users.remove(user1)
        except cls.DoesNotExist:
            pass  # 친구 관계가 존재하지 않는 경우 아무 작업도 하지 않음

    @classmethod
    def are_friends(cls, user1, user2):
        """두 사용자가 친구인지 확인합니다."""
        try:
            friend1 = cls.objects.get(current_user=user1)
            return friend1.users.filter(pk=user2.pk).exists()
        except cls.DoesNotExist:
            return False
