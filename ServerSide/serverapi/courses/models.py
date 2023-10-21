from django.db import models

class Course(models.Model):
    subj = models.CharField(max_length=50, verbose_name='Subj')
    course_number = models.CharField(max_length=10, db_column='#', verbose_name='#')
    title = models.CharField(max_length=255, verbose_name='Title')
    comp_numb = models.IntegerField(verbose_name='Comp Numb')
    section = models.CharField(max_length=10, verbose_name='Sec')
    ptrm = models.CharField(max_length=10, verbose_name='Ptrm')
    lec_lab = models.CharField(max_length=10, verbose_name='Lec Lab')
    attr = models.TextField(null=True, blank=True, verbose_name='Attr')
    camp_code = models.CharField(max_length=10, verbose_name='Camp Code')
    coll_code = models.CharField(max_length=10, verbose_name='Coll Code')
    max_enrollment = models.IntegerField(verbose_name='Max Enrollment')
    current_enrollment = models.IntegerField(verbose_name='Current Enrollment')
    true_max = models.IntegerField(verbose_name='True Max')
    start_time = models.CharField(verbose_name='Start Time', max_length=16, null=True, blank=True)
    end_time = models.CharField(verbose_name='End Time', max_length=16, null=True, blank=True)
    days = models.CharField(max_length=10, null=True, blank=True,  verbose_name='Days')
    credits = models.CharField(max_length=255, verbose_name='Credits')
    bldg = models.CharField(max_length=50, null=True, blank=True, verbose_name='Bldg')
    room = models.CharField(max_length=50, null=True, blank=True, verbose_name='Room')
    gp_ind = models.CharField(max_length=10, verbose_name='GP Ind')
    instructor = models.CharField(max_length=255, verbose_name='Instructor')
    netid = models.CharField(max_length=100, verbose_name='NetId')
    email = models.EmailField(verbose_name='Email')
    fees = models.TextField(null=True, blank=True, verbose_name='Fees')
    xlistings = models.TextField(null=True, blank=True, verbose_name='XListings')

    def __str__(self):
        return self.title
