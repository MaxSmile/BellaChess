// Minimal telemetry wrapper.
//
// Goals (M2.5):
// - allow us to emit a few key events early (without committing to a vendor)
// - default to NO-OP in local/dev unless GA is configured
//
// If NEXT_PUBLIC_GA4_ID is set and the GA script is loaded, we forward events to gtag.

export type TelemetryEventName =
  | 'page_view'
  | 'try_play_started'
  | 'game_started'
  | 'move_made'
  | 'game_completed';

export type TelemetryProps = Record<string, string | number | boolean | null | undefined>;

declare global {
  interface Window {
    gtag?: (...args: any[]) => void;
  }
}

export function track(event: TelemetryEventName, props: TelemetryProps = {}) {
  if (typeof window === 'undefined') return;

  // If GA isn't configured, keep it silent in prod but visible in dev.
  const hasGtag = typeof window.gtag === 'function';

  if (hasGtag) {
    window.gtag('event', event, props);
    return;
  }

  if (process.env.NODE_ENV !== 'production') {
    // eslint-disable-next-line no-console
    console.debug('[telemetry]', event, props);
  }
}
