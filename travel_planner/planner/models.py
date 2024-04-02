from django.db import models

class activity_category(models.Model):
    name = models.TextField()
    quantity = models.IntegerField()

class activity(models.Model):
    name = models.TextField()
    price = models.TextField()
    photo = models.ImageField(upload_to='activity_photo/')
    location = models.TextField()
    telephone = models.TextField()
    time = models.TextField()
    category = models.ForeignKey(activity_category, on_delete=models.CASCADE)
    def save(self, *args, **kwargs):
        # 관광지가 저장될 때 카테고리의 수량 업데이트
        if self.activity_category:
            self.activity_category.quantity += 1  # 카테고리 수량 증가
            self.activity_category.save()
        super().save(*args, **kwargs)
    def delete(self, *args, **kwargs):
        # 관광지가 삭제될 때 카테고리의 수량 업데이트
        if self.activity_category:
            self.activity_category.quantity -= 1  # 카테고리 수량 감소
            self.activity_category.save()
        super().delete(*args, **kwargs)

class TripPlan(models.Model):
    arrival_date = models.DateField()
    total_people = models.IntegerField(default=0)  # 성인, 학생, 어린이 인원 수를 합친 총 인원 수
