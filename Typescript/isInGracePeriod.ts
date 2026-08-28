import { differenceInCalendarDays, startOfDay } from 'date-fns';
import { utcToZonedTime } from 'date-fns-tz';

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

export function isInGracePeriod(
  now: Date,
  tncLinkSentTimestamp: Date,
  timezone: string,
  maxDaysAllowedNoESignature: number | undefined,
): boolean {
  if (!maxDaysAllowedNoESignature) {
    throw new Error('Missing maxDaysAllowedNoESignature');
  }
  const diffInDays = compareDate(now, tncLinkSentTimestamp, timezone);
  return diffInDays <= maxDaysAllowedNoESignature;
}

// Example usage (you can modify or remove this)
if (require.main === module) {
  // The UTC time the billing job runs, and when the T&C link was sent.
  const now = new Date('2026-08-27T15:50:00Z');
  const tncLinkSentTimestamp = new Date('2026-08-13T03:00:00.000Z');
  const timezone = 'America/New_York';
  const maxDaysAllowedNoESignature = 14;

  const diffInDays = compareDate(now, tncLinkSentTimestamp, timezone);
  const within = isInGracePeriod(
    now,
    tncLinkSentTimestamp,
    timezone,
    maxDaysAllowedNoESignature,
  );

  console.log('now:', now.toISOString());
  console.log('tncLinkSentTimestamp:', tncLinkSentTimestamp.toISOString());
  console.log('timezone:', timezone);
  console.log('maxDaysAllowedNoESignature:', maxDaysAllowedNoESignature);
  console.log(`compareDate diffInDays: ${diffInDays}`);
  console.log(
    `isInGracePeriod (diffInDays <= max): ${within ? 'true (still in grace period)' : 'false (grace period over)'}`,
  );
}
