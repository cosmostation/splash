import _duration from 'dayjs/plugin/duration';
import { call } from './utils';
import dayjs from 'dayjs';

export const getTotalTime = (unix): string => dayjs(unix).format('YYYY-MM-DD HH:mm:ss');

export const setAgoTime = (time?: string | number, onlySecond?: boolean): string => {
  if (!time) {
    return '';
  }

  const x = dayjs();
  const y = dayjs(time);

  dayjs.extend(_duration);
  const duration = dayjs.duration(x.diff(y));

  if (onlySecond) {
    return String(duration.asMilliseconds());
  }

  const returnAgo = call(() => {
    if (duration.years()) return `${duration.years()} years`;
    else if (duration.months()) return `${duration.months()} months`;
    else if (duration.days()) return `${duration.days()} days`;
    else if (duration.hours()) return `${duration.hours()}h`;
    else if (duration.minutes()) return `${duration.minutes()}m`;
    else if (duration.seconds()) return `${duration.seconds()}s`;

    return '0s';
  });

  return `${returnAgo} ago`;
};

export const setLeftTime = (time?: string, suffix = 'remaining'): string => {
  const x = dayjs();
  const y = dayjs(time);

  dayjs.extend(_duration);
  const duration = dayjs.duration(y.diff(x));

  if (dayjs.duration(y.diff(x)).asDays() > 30) {
    return `${Math.floor(dayjs.duration(y.diff(x)).asDays())} days ${suffix}`;
  }

  const returnAgo = call(() => {
    if (duration.years()) return `${duration.years()} years`;
    else if (duration.months()) return `${duration.months()} months`;
    else if (duration.days()) return `${duration.days()} days`;
    else if (duration.hours()) return `${duration.hours()}h`;
    else if (duration.minutes()) return `${duration.minutes()}m`;
    else if (duration.seconds()) return `${duration.seconds()}s`;

    return '0s';
  });

  return `${returnAgo} ${suffix}`;
};

export const setDaytoSecond = (second?: string): string => {
  const splitSecond = Number(second?.split('s')[0]);
  const days = Math.floor(splitSecond / 3600 / 24);
  const hour = Math.floor(splitSecond / 3600);

  if (hour >= 24) {
    return `${days} days`;
  } else if (days < 24 && hour >= 1) {
    return `${hour} h`;
  }

  return `${splitSecond} s`;
};
