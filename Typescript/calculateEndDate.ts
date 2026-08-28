import { add, differenceInCalendarDays, startOfDay } from 'date-fns';
import { utcToZonedTime, zonedTimeToUtc } from 'date-fns-tz';

function isValidTimeZone(timeZone: string): boolean {
  try {
    Intl.DateTimeFormat(undefined, { timeZone });
    return true;
  } catch {
    return false;
  }
}

export function compareDate(
  endDate: Date,
  startDate: Date,
  timeZone: string,
): number {
  if (!(startDate instanceof Date) || isNaN(startDate.getTime())) {
    throw new Error('Invalid start date');
  }

  if (!(endDate instanceof Date) || isNaN(endDate.getTime())) {
    throw new Error('Invalid end date');
  }

  if (typeof timeZone !== 'string' || !isValidTimeZone(timeZone)) {
    throw new Error('Invalid timezone');
  }

  const startOfDayInZone = startOfDay(utcToZonedTime(startDate, timeZone));
  const endOfDayInZone = startOfDay(utcToZonedTime(endDate, timeZone));

  return differenceInCalendarDays(endOfDayInZone, startOfDayInZone);
}

export function calculateEndDate(
  diffInDays: number,
  startDate: Date,
  timeZone: string,
): Date {
  if (!(startDate instanceof Date) || isNaN(startDate.getTime())) {
    throw new Error('Invalid start date');
  }

  if (!Number.isInteger(diffInDays) || isNaN(diffInDays)) {
    throw new Error('Invalid date difference');
  }

  if (typeof timeZone !== 'string' || !isValidTimeZone(timeZone)) {
    throw new Error('Invalid timezone');
  }

  // Convert startDate to the timezone and get start of that day
  const startOfDayInZone = startOfDay(utcToZonedTime(startDate, timeZone));
  
  // Add the difference in days
  const endOfDayInZone = add(startOfDayInZone, { days: diffInDays });
  
  // Convert back to UTC, keeping it at midnight in the local timezone
  return zonedTimeToUtc(endOfDayInZone, timeZone);
}

// Example usage (you can modify or remove this)
if (require.main === module) {
  // This is the UTC time when our billing service runs
  const startDate = new Date('2026-08-27T08:05:00Z');
  const diffInDays = 14;
  const timeZone = "Canada/Eastern";
  
  const endDate = calculateEndDate(diffInDays, startDate, timeZone);
  console.log('Start Date:', startDate.toISOString());
  console.log('End Date:', endDate.toISOString());
  console.log(`Input Difference: ${diffInDays} days`);
  
  // Verify the inverse relationship
  const calculatedDiff = compareDate(endDate, startDate, timeZone);
  console.log(`Calculated Difference (from compareDate): ${calculatedDiff} days`);
  console.log(`Match: ${calculatedDiff === diffInDays ? '✓' : '✗'}`);
  
  // Show the end date is at midnight in the local timezone
  console.log(`End Date in UTC:`, endDate.toISOString());
}
