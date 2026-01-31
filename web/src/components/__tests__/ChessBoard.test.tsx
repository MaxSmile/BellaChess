import React from 'react';
import { render, screen } from '@testing-library/react';
import ChessBoard from '../ChessBoard';

describe('ChessBoard', () => {
  it('renders the board title', () => {
    render(<ChessBoard />);
    expect(screen.getByText('BellaChess Board')).toBeInTheDocument();
  });

  it('shows current player indicator', () => {
    render(<ChessBoard />);
    expect(screen.getByText(/Current player:/i)).toBeInTheDocument();
  });
});
