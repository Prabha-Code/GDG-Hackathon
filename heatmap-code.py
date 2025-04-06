import firebase_admin
from firebase_admin import credentials, db
import matplotlib.pyplot as plt
import numpy as np
import time

# Initialize Firebase
cred = credentials.Certificate("gdg00-d79b5-firebase-adminsdk-fbsvc-b00146d918.json")
if not firebase_admin._apps:
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://gdg00-d79b5-default-rtdb.firebaseio.com/'
    })

# Fetch moisture data
def fetch_latest_data():
    ref = db.reference('/')
    data = ref.get()
    print("Fetched:", data)

    moisture_data = {}
    for i in range(1, 5):
        key = f"moisture{i}"
        if key in data:
            try:
                moisture_data[f"Sensor{i}"] = float(data[key])
            except ValueError:
                moisture_data[f"Sensor{i}"] = 0.0
    return moisture_data

# Color mapping: 100 = Dry = Red, 0 = Wet = Blue
def get_color_map(moisture_levels):
    low_threshold = 40    # Wet
    high_threshold = 100  # Dry

    color_map = []
    for m in moisture_levels:
        if m >= high_threshold:
            color_map.append([1.0, 0.0, 0.0])  # Red = Dry
        elif m > low_threshold:
            color_map.append([1.0, 1.0, 0.0])  # Yellow = Medium
        else:
            color_map.append([0.0, 0.0, 1.0])  # Blue = Wet

    return np.array(color_map).reshape(2, 2, 3)

# Plot heatmap in grid layout
def plot_heatmap(data):
    sensors = ["Sensor1", "Sensor2", "Sensor3", "Sensor4"]
    values = [data.get(s, 0) for s in sensors]

    color_map_array = get_color_map(values)

    fig, ax = plt.subplots(figsize=(6, 6))
    ax.imshow(color_map_array, aspect='equal')

    sensor_labels = np.array(sensors).reshape(2, 2)
    value_labels = np.array(values).reshape(2, 2)

    for i in range(2):
        for j in range(2):
            ax.text(j, i, f"{sensor_labels[i][j]}\n{value_labels[i][j]:.0f}",
                    ha='center', va='center',
                    fontsize=12, fontweight='bold', color='black',
                    bbox=dict(facecolor='white', alpha=0.6, edgecolor='none'))

    ax.set_xticks([])
    ax.set_yticks([])
    ax.set_title("Soil Moisture Heatmap", fontsize=14, fontweight='bold', pad=20)
    plt.tight_layout()
    plt.show(block=False)
    plt.pause(5)
    plt.close()

# Real-time loop
plt.ion()
try:
    while True:
        moisture_data = fetch_latest_data()
        if moisture_data:
            plot_heatmap(moisture_data)
        time.sleep(5)
except KeyboardInterrupt:
    print("\nExiting heatmap monitor.")
