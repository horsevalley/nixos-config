#!/usr/bin/env python3
import pandas as pd
import re
from datetime import datetime

def clean_phone_number(phone):
    if pd.isna(phone):
        return ''
    # Remove non-digit characters
    digits = re.sub(r'\D', '', str(phone))
    # Format as +47 XXX XX XXX if it's a Norwegian number
    if len(digits) == 8:
        return f'+47 {digits[:3]} {digits[3:5]} {digits[5:]}'
    return digits

def clean_date(date):
    if pd.isna(date):
        return ''
    try:
        return datetime.strptime(str(date), '%Y-%m-%d').strftime('%Y-%m-%d')
    except ValueError:
        return ''

def clean_csv(input_file, output_file):
    # Read the CSV file
    df = pd.read_csv(input_file, encoding='utf-8')

    # Standardize name fields
    df['Name'] = df['Name'].combine_first(df['Given Name'] + ' ' + df['Family Name'])
    df['Given Name'] = df['Given Name'].fillna('')
    df['Family Name'] = df['Family Name'].fillna('')

    # Consolidate address information
    address_fields = ['Address 1 - Formatted', 'Address 1 - Street', 'Address 1 - City', 
                      'Address 1 - Region', 'Address 1 - Postal Code', 'Address 1 - Country']
    df['Address'] = df[address_fields].apply(lambda x: ', '.join(x.dropna().astype(str)), axis=1)

    # Standardize phone number format
    phone_fields = [col for col in df.columns if 'Phone' in col and 'Type' not in col]
    for field in phone_fields:
        df[field] = df[field].apply(clean_phone_number)

    # Standardize date format
    df['Birthday'] = df['Birthday'].apply(clean_date)

    # Consolidate email fields
    df['Email'] = df['E-mail 1 - Value'].fillna(df['E-mail 2 - Value'])

    # Clean up notes
    df['Notes'] = df['Notes'].fillna('').apply(lambda x: x.replace('\n', ' ').strip())

    # Select and reorder columns
    columns_to_keep = ['Name', 'Given Name', 'Family Name', 'Birthday', 'Email', 'Phone 1 - Value', 
                       'Phone 2 - Value', 'Address', 'Organization 1 - Name', 'Notes']
    df = df[columns_to_keep]

    # Remove rows where all fields are empty
    df = df.dropna(how='all')

    # Write the cleaned data to a new CSV file
    df.to_csv(output_file, index=False, encoding='utf-8')

    print(f"Cleaned CSV file has been saved as {output_file}")

if __name__ == "__main__":
    input_file = "contacts.csv"
    output_file = "cleaned_contacts.csv"
    clean_csv(input_file, output_file)
