from Accounts.models import *
from django.db import models



class Package(models.Model):
    destination = models.CharField(max_length=100)
    start_date = models.DateField()
    end_date = models.DateField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='package_images/')  # 이미지 필드 추가

    def __str__(self):
        return f"{self.destination} ({self.start_date} - {self.end_date})"


class Booking(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    package = models.ForeignKey(Package, on_delete=models.CASCADE)
    number_of_people = models.IntegerField()

    def __str__(self):
        return f"Booking by {self.user.username} for {self.number_of_people} people"