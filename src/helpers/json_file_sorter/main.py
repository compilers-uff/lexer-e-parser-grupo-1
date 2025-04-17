"""
Module that sorts two given JSON files by KeyName.
Used for comparing ASTs in order to identify differences between reference and student outputs.
"""

# Imports
import json
import logging

# Define logger
logger = logging.getLogger(__name__)

# Read File 1
with open('./data/file_1.json', 'r', encoding="utf-8") as file:
    file_1_data = json.load(file)
    logger.info("File 1 loaded successfully.")

# Save Sorted File 1
with open('./data/file_1.json', 'w', encoding="utf-8") as file:
    json.dump(file_1_data, file, indent=4, ensure_ascii=False, sort_keys=True)
    logger.info("Sorted File 1 saved successfully.")

# File 2
with open('./data/file_2.json', 'r', encoding="utf-8") as file:
    file_2_data = json.load(file)
    logger.info("File 2 loaded successfully.")

# Save Sorted File 2
with open('./data/file_2.json', 'w', encoding="utf-8") as file:
    json.dump(file_2_data, file, indent=4, ensure_ascii=False, sort_keys=True)
    logger.info("Sorted File 2 saved successfully.")
