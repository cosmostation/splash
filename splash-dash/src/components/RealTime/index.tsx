import { useEffect, useState } from 'react';

import { useInterval } from 'src/hooks/useInterval';

export default function RealTime({ value, generator }) {
  const [timeAgo, setTimeAgo] = useState(generator(value));

  useEffect(() => {
    setTimeAgo(generator(value));
  }, [value]);

  useInterval(() => {
    setTimeAgo(generator(value));
  }, 4500);

  return timeAgo;
}
