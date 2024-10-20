const mongoose = require('mongoose');

const {{TYPE}}Schema = new mongoose.Schema({
  // Define your {{TYPE}} fields here
  name: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('{{TYPE}}', {{TYPE}}Schema);
