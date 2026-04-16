/**
 * Urgency Score Calculator
 *
 * Computes a 0-100 urgency score for blood requests.
 * This determines priority queue position.
 *
 * Score Breakdown:
 * - Patient condition:  0-40 pts (critical=40, urgent=25, standard=10)
 * - Surgery window:     0-30 pts (closer = higher)
 * - Blood type rarity:  0-20 pts (AB-=20, B-/A-=15, O-=10, etc.)
 * - Units needed:       0-10 pts (2 pts per unit, max 10)
 */

function computeUrgency(req) {
  let score = 0;

  // Condition weight (0-40 pts)
  if (req.condition === 'critical') score += 40;
  else if (req.condition === 'urgent') score += 25;
  else score += 10;

  // Surgery window (0-30 pts)
  if (req.surgeryTime) {
    const surgeryMs = req.surgeryTime.toMillis
      ? req.surgeryTime.toMillis()
      : new Date(req.surgeryTime).getTime();
    const hoursLeft = (surgeryMs - Date.now()) / 3600000;
    score += Math.max(0, Math.min(30, 30 - hoursLeft * 3));
  }

  // Blood type rarity (0-20 pts)
  const rarityMap = {
    'AB-': 20,
    'B-': 15,
    'A-': 15,
    'O-': 10,
    'AB+': 8,
    'B+': 5,
    'A+': 5,
    'O+': 3,
  };
  score += rarityMap[req.bloodGroup] || 5;

  // Units needed (0-10 pts)
  score += Math.min(10, (req.units || 1) * 2);

  return Math.min(100, Math.round(score));
}

module.exports = { computeUrgency };
