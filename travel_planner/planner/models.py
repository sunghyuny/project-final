from django.db import models

# Create your models here.
class TravelPlan(models.Model):
    date = models.DateField()
    destination = models.CharField(max_length=20)
    participants = models.PositiveIntegerField()
    accommodation = models.CharField(max_length=20)
    attractions = models.CharField(max_length=20)
    restaurants = models.CharField(max_length=20)
    experience = models.CharField(max_length=20)
    exhibition = models.CharField(max_length=20)

    def __str__(self):
        return f"{self.date} - {self.destination}"
