# Tokenized Community Garden Tool Library System

A decentralized tool library management system built on Stacks blockchain using Clarity smart contracts. This system enables community gardens to efficiently manage tool inventory, borrowing, maintenance, and expansion planning.

## System Overview

The system consists of five interconnected smart contracts:

### 1. Equipment Inventory Contract (`equipment-inventory.clar`)
- Manages comprehensive tool catalog with unique identifiers
- Tracks tool availability, condition, and specifications
- Handles tool registration and status updates
- Maintains tool categories and metadata

### 2. Borrowing Agreement Contract (`borrowing-agreement.clar`)
- Processes tool checkout and return procedures
- Manages borrower information and lending history
- Enforces borrowing limits and due date tracking
- Handles late return penalties and restrictions

### 3. Maintenance Responsibility Contract (`maintenance-responsibility.clar`)
- Coordinates tool repair and maintenance scheduling
- Manages maintenance funding and cost tracking
- Tracks maintenance history and service providers
- Handles warranty and replacement decisions

### 4. Usage Analytics Contract (`usage-analytics.clar`)
- Monitors tool usage patterns and popularity metrics
- Generates community usage reports and insights
- Tracks seasonal demand fluctuations
- Provides data for informed decision making

### 5. Expansion Planning Contract (`expansion-planning.clar`)
- Manages community requests for new equipment
- Prioritizes tool acquisition based on demand and budget
- Tracks funding sources and acquisition timelines
- Handles voting on new tool purchases

## Key Features

- **Decentralized Governance**: Community-driven decision making for tool acquisition and policies
- **Transparent Tracking**: All transactions and tool status changes recorded on blockchain
- **Automated Scheduling**: Smart contract-based borrowing and maintenance scheduling
- **Analytics Dashboard**: Real-time insights into tool usage and community needs
- **Funding Management**: Transparent handling of maintenance and expansion funds

## Contract Architecture

Each contract operates independently while sharing common data structures:

- **Tool ID System**: Unique identifiers for consistent tool tracking
- **User Management**: Principal-based user identification and permissions
- **Status Tracking**: Standardized condition and availability states
- **Event Logging**: Comprehensive activity logging for transparency

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js for testing framework

### Installation
1. Clone the repository
2. Install dependencies: \`npm install\`
3. Run tests: \`npm test\`
4. Deploy contracts to testnet/mainnet

### Usage Examples

#### Registering a New Tool
\`\`\`clarity
(contract-call? .equipment-inventory register-tool
"Shovel"
"Heavy-duty garden shovel"
"gardening"
"excellent")
\`\`\`

#### Borrowing a Tool
\`\`\`clarity
(contract-call? .borrowing-agreement borrow-tool
u1
u7) ;; borrow for 7 days
\`\`\`

#### Scheduling Maintenance
\`\`\`clarity
(contract-call? .maintenance-responsibility schedule-maintenance
u1
"Blade sharpening"
u50) ;; 50 STX cost
\`\`\`

## Testing

The system includes comprehensive Vitest-based tests covering:
- Contract deployment and initialization
- Tool registration and management
- Borrowing workflows
- Maintenance scheduling
- Analytics data collection
- Expansion planning processes

Run tests with: \`npm test\`

## Contributing

1. Fork the repository
2. Create feature branch
3. Add tests for new functionality
4. Submit pull request with detailed description

## License

MIT License - see LICENSE file for details

## Community

Join our community garden tool library initiative:
- Discord: [Community Garden Tools]
- Forum: [Garden Library Discussions]
- Email: tools@communitygarden.org
