import { useNavigate as useBaseNavigate, useLocation } from 'react-router-dom';

import type { NavigateOptions } from 'react-router-dom';

export function useNavigate() {
  const baseNavigate = useBaseNavigate();
  const { pathname } = useLocation();

  const navigate = (to: string, options?: NavigateOptions & { isDuplicateCheck?: boolean }) => {
    if (options?.isDuplicateCheck && pathname === to) {
      return;
    }

    baseNavigate(to, options);
  };

  const link = (to: string): string => {
    return to;
  };

  const navigateBack = (delta = -1) => {
    baseNavigate(delta);
  };

  return { navigate, navigateBack, link };
}
