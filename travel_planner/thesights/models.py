from django.db import models

class RegionCategory(models.Model):
    name = models.CharField(max_length=100)
    quantity = models.IntegerField(default=0)  # 카테고리 수량 필드 추가

    def __str__(self):
        return self.name

class TouristSpot(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    location = models.CharField(max_length=255)
    region_category = models.ForeignKey(RegionCategory, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='tourist_spots/', blank=True, null=True)

    def save(self, *args, **kwargs):
        # 관광지가 저장될 때 카테고리의 수량 업데이트
        if self.region_category:
            self.region_category.quantity += 1  # 카테고리 수량 증가
            self.region_category.save()
        super().save(*args, **kwargs)

    def delete(self, *args, **kwargs):
        # 관광지가 삭제될 때 카테고리의 수량 업데이트
        if self.region_category:
            self.region_category.quantity -= 1  # 카테고리 수량 감소
            self.region_category.save()
        super().delete(*args, **kwargs)
