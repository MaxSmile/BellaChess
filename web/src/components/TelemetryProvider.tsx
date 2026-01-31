'use client';

import { useEffect } from 'react';
import { usePathname, useSearchParams } from 'next/navigation';
import { track } from '@/lib/telemetry';

// Emits basic page_view events on route changes.
export default function TelemetryProvider() {
  const pathname = usePathname();
  const searchParams = useSearchParams();

  useEffect(() => {
    const url = pathname + (searchParams?.toString() ? `?${searchParams.toString()}` : '');
    track('page_view', { page_path: url });
  }, [pathname, searchParams]);

  return null;
}
