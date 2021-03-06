import { Box } from "palette"
import React from "react"

export const ScreenMargin: React.FC = ({ children }) => {
  return <Box px={2}>{children}</Box>
}
