/**
 * RaktSetu Cloud Functions — Main Entry Point
 *
 * All business logic is organized into modules under src/.
 * Each function is single-responsibility and independently deployable.
 */

const admin = require('firebase-admin');
admin.initializeApp();

// ── Matching Engine ──
const { onRequestCreated } = require('./src/matching/onRequestCreated');
const { onDonorAccept } = require('./src/matching/onDonorAccept');

// ── Scoring ──
// Urgency scoring is integrated into onRequestCreated

// ── Notifications ──
const { notificationOrchestrator } = require('./src/notifications/orchestrator');

// ── AI / ML ──
const { donorEligibilityChat } = require('./src/ai/eligibilityChat');
const { demandForecast } = require('./src/ai/demandForecast');

// ── Scheduling ──
const { escalationScheduler } = require('./src/scheduling/escalation');
const { donationCooldownCheck } = require('./src/scheduling/donationCooldown');

// ── Camps ──
const { campCertificateGen } = require('./src/camps/certificateGenerator');

// ── Inventory ──
const { inventorySync } = require('./src/inventory/inventorySync');

// ── Leaderboard ──
const { leaderboardUpdater } = require('./src/leaderboard/leaderboardUpdater');

// ── Export all functions ──
exports.onRequestCreated = onRequestCreated;
exports.onDonorAccept = onDonorAccept;
exports.notificationOrchestrator = notificationOrchestrator;
exports.donorEligibilityChat = donorEligibilityChat;
exports.demandForecast = demandForecast;
exports.escalationScheduler = escalationScheduler;
exports.donationCooldownCheck = donationCooldownCheck;
exports.campCertificateGen = campCertificateGen;
exports.inventorySync = inventorySync;
exports.leaderboardUpdater = leaderboardUpdater;
