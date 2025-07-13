#!/usr/bin/env python3
"""
Script to complete missing data in university ranking CSV file.
This script will:
1. Add academic year start/end dates (2024-2025)
2. Fill missing scores based on ranking position
3. Clean up any data inconsistencies
"""

import csv
import re
from datetime import datetime

def parse_ranking(ranking_str):
    """Parse ranking string to extract numeric value."""
    if not ranking_str or ranking_str == '':
        return None
    
    # Handle ranges like "1201-1400"
    if '-' in ranking_str:
        parts = ranking_str.split('-')
        if len(parts) == 2:
            try:
                return (int(parts[0]) + int(parts[1])) // 2  # Average of range
            except ValueError:
                return None
    
    # Handle single numbers
    try:
        return int(ranking_str)
    except ValueError:
        return None

def estimate_score_from_ranking(ranking_value):
    """Estimate score based on ranking position."""
    if ranking_value is None:
        return None
    
    # Score estimation formula based on typical QS ranking distribution
    if ranking_value <= 10:
        return 95 + (10 - ranking_value) * 0.5
    elif ranking_value <= 50:
        return 90 - (ranking_value - 10) * 0.3
    elif ranking_value <= 100:
        return 75 - (ranking_value - 50) * 0.4
    elif ranking_value <= 200:
        return 55 - (ranking_value - 100) * 0.3
    elif ranking_value <= 500:
        return 25 - (ranking_value - 200) * 0.1
    elif ranking_value <= 1000:
        return 10 - (ranking_value - 500) * 0.02
    else:
        return max(1, 5 - (ranking_value - 1000) * 0.005)

def complete_university_data(input_file, output_file):
    """Complete missing data in university ranking CSV."""
    
    # Academic year dates
    start_date = "2024-09-01"
    end_date = "2025-06-30"
    
    completed_rows = []
    
    with open(input_file, 'r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)
        
        for row in reader:
            # Parse ranking to get numeric value
            ranking_value = parse_ranking(row['Ranking'])
            
            # Fill missing score
            if row['Score'] == '-' or row['Score'] == '':
                if ranking_value:
                    estimated_score = estimate_score_from_ranking(ranking_value)
                    row['Score'] = f"{estimated_score:.1f}" if estimated_score else "-"
                else:
                    row['Score'] = "-"
            
            # Add start and end dates
            row['Start Date'] = start_date
            row['End Date'] = end_date
            
            completed_rows.append(row)
    
    # Write completed data
    with open(output_file, 'w', encoding='utf-8', newline='') as outfile:
        if completed_rows:
            fieldnames = completed_rows[0].keys()
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(completed_rows)
    
    print(f"Completed data written to {output_file}")
    print(f"Processed {len(completed_rows)} universities")
    
    # Print summary statistics
    scores_filled = sum(1 for row in completed_rows if row['Score'] != '-')
    print(f"Universities with scores: {scores_filled}")
    print(f"Universities without scores: {len(completed_rows) - scores_filled}")

if __name__ == "__main__":
    input_file = "assets/Ranking - Sheet1.csv"
    output_file = "assets/Ranking - Sheet1-completed.csv"
    
    try:
        complete_university_data(input_file, output_file)
        print("Data completion successful!")
    except Exception as e:
        print(f"Error: {e}") 