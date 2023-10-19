import pandas as pd
from django.core.management import BaseCommand
from courses.models import Course
import requests
from io import StringIO


class Command(BaseCommand):

    def handle(self, *args, **options):
        updated = 0
        made = 0
        url = "https://serval.uvm.edu/~rgweb/batch/curr_enroll_fall.txt"
        response = requests.get(url, verify=False)
        data = StringIO(response.text)

        df = pd.read_csv(data, header=0)
        df['True Max'] = df['True Max'].fillna(0).astype(int)

        def convert_time(val):
            if val == 'TBA' or pd.isna(val):
                return None
            return pd.to_datetime(val).time()

        df['Start Time'] = df['Start Time'].apply(convert_time)

        for _, row in df.iterrows():
            # Create or update the Course instance
            course, created = Course.objects.update_or_create(
                comp_numb=row['Comp Numb'],
                defaults={
                    'subj': row[' Subj'],
                    'course_number': row['#'],
                    'title': row['Title'],
                    'section': row['Sec'],
                    'comp_numb': row['Comp Numb'],
                    'ptrm': row['Ptrm'],
                    'lec_lab': row['Lec Lab'],
                    'camp_code': row['Camp Code'],
                    'coll_code': row['Coll Code'],
                    'max_enrollment': row['Max Enrollment'],
                    'current_enrollment': row['Current Enrollment'],
                    'true_max': row['True Max'],
                    'start_time': row['Start Time'],
                    'end_time': row['End Time'],
                    'days': row['Days'],
                    'credits': row['Credits'],
                    'bldg': row['Bldg'],
                    'room': row['Room'],
                    'gp_ind': row['GP Ind'],
                    'instructor': row['Instructor'],
                    'netid': row['NetId'],
                    'email': row['Email'],
                    'fees': row['Fees'],
                    'xlistings': row['XListings']
                }
            )
            if created:
                made += 1
            else:
                updated += 1

        self.stdout.write(self.style.SUCCESS('Import completed! {} created, {} updated'.format(made, updated)))
