import pandas as pd

#importing rise and accel data from csvs
rise_url = r'C:\Users\LindsayChu\Downloads\Linear_Slopes_mmyearly.csv'
rise_csv = pd.read_csv(rise_url)
rise_csv.info()

accel_url = r'C:\Users\LindsayChu\Downloads\Accelerations.csv'
accel_csv = pd.read_csv(accel_url)
accel_csv.info()

#compute means from both dataframes
rise_mean = rise_csv['LinearSlope'].mean()
accel_mean = accel_csv['Acceleration(mm/year^2)'].mean()

print(f"Mean rise: {rise_mean}")
print(f"Mean acceleration: {accel_mean}")


#add column to each dataframe with deviation from mean
rise_csv['Dev_rise'] = rise_csv['LinearSlope'] - rise_mean
accel_csv['Dev_accel'] = accel_csv['Acceleration(mm/year^2)'] - accel_mean

# finding differences between the two deviations
# merge the two dataframes on the 'City' column
merged_csv = pd.merge(rise_csv, accel_csv, on='City')
merged_csv['rise_accel_diff'] = merged_csv['Dev_rise'] - merged_csv['Dev_accel']
merged_csv['abs_diff'] = merged_csv['rise_accel_diff'].abs()
merged_csv['rise_accel_diff'] = merged_csv['rise_accel_diff'].astype(float)
merged_csv['abs_diff'] = merged_csv['abs_diff'].astype(float)
print(merged_csv.head())

merged_csv.to_csv(r'C:\Users\LindsayChu\Downloads\all_diffs.csv', index=False)