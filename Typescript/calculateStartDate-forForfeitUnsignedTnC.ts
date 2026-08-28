// 1. Navigate to the Typescript folder
// 2. Run `yarn ts-node ./calculateStartDate-forForfeitUnsignedTnC.ts`

import { differenceInCalendarDays, startOfDay, sub } from 'date-fns';
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

export function calculateStartDate(
  diffInDays: number,
  endDate: Date,
  timeZone: string,
): Date {
  if (!(endDate instanceof Date) || isNaN(endDate.getTime())) {
    throw new Error('Invalid end date');
  }

  if (!Number.isInteger(diffInDays) || isNaN(diffInDays)) {
    throw new Error('Invalid date difference');
  }

  if (typeof timeZone !== 'string' || !isValidTimeZone(timeZone)) {
    throw new Error('Invalid timezone');
  }

  // Convert endDate to the timezone and get start of that day
  const endOfDayInZone = startOfDay(utcToZonedTime(endDate, timeZone));

  // Subtract the difference in days
  const startOfDayInZone = sub(endOfDayInZone, { days: diffInDays });

  // Convert back to UTC, keeping it at midnight in the local timezone
  const startDateUtc = zonedTimeToUtc(startOfDayInZone, timeZone);

  // Step back one more hour so the result lands on the previous calendar day
  // in the local timezone. That makes the gap `diffInDays + 1`, which is
  // strictly greater than maxDaysAllowedNoESignature, so isInGracePeriod is false.
  return sub(startDateUtc, { hours: 1 });
}

// Example usage (you can modify or remove this)
if (require.main === module) {
  // This is the UTC time when our billing service runs
  const endDate = new Date('2026-08-27T15:50:00Z');
  const diffInDays = 14;
  const timeZone = "America/New_York";

  const startDate = calculateStartDate(diffInDays, endDate, timeZone);
  console.log('End Date:', endDate.toISOString());
  console.log('Start Date:', startDate.toISOString());
  console.log(`Input Difference: ${diffInDays} days`);

  // The extra hour pushes the start date one calendar day earlier,
  // so compareDate should report diffInDays + 1.
  const calculatedDiff = compareDate(endDate, startDate, timeZone);
  console.log(`Calculated Difference (from compareDate): ${calculatedDiff} days`);
  console.log(
    `Match (expected ${diffInDays + 1}): ${calculatedDiff === diffInDays + 1 ? '✓' : '✗'}`,
  );
  console.log(
    `Out of grace period (diffInDays > max): ${calculatedDiff > diffInDays ? 'true' : 'false'}`,
  );

  // Show the start date is one hour before midnight in the local timezone
  console.log(`Start Date in UTC:`, startDate.toISOString());
}
