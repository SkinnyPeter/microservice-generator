const {{TYPE}} = require('../models/{{TYPE}}');

// @desc    Get all {{TYPE}}s
// @route   GET /api/{{TYPE}}s
// @access  Public
exports.get{{TYPE}}s = async (req, res) => {
  try {
    const {{TYPE}}s = await {{TYPE}}.find();
    res.status(200).json({{TYPE}}s);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// @desc    Get a single {{TYPE}}
// @route   GET /api/{{TYPE}}s/:id
// @access  Public
exports.get{{TYPE}}ById = async (req, res) => {
  try {
    const {{TYPE}} = await {{TYPE}}.findById(req.params.id);
    if (!{{TYPE}}) {
      return res.status(404).json({ message: '{{TYPE}} not found' });
    }
    res.status(200).json({{TYPE}});
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// @desc    Create a new {{TYPE}}
// @route   POST /api/{{TYPE}}s
// @access  Public
exports.create{{TYPE}} = async (req, res) => {
  try {
    const new{{TYPE}} = new {{TYPE}}(req.body);
    const saved{{TYPE}} = await new{{TYPE}}.save();
    res.status(201).json(saved{{TYPE}});
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// @desc    Update a {{TYPE}}
// @route   PUT /api/{{TYPE}}s/:id
// @access  Public
exports.update{{TYPE}} = async (req, res) => {
  try {
    const updated{{TYPE}} = await {{TYPE}}.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!updated{{TYPE}}) {
      return res.status(404).json({ message: '{{TYPE}} not found' });
    }
    res.status(200).json(updated{{TYPE}});
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// @desc    Delete a {{TYPE}}
// @route   DELETE /api/{{TYPE}}s/:id
// @access  Public
exports.delete{{TYPE}} = async (req, res) => {
  try {
    const deleted{{TYPE}} = await {{TYPE}}.findByIdAndDelete(req.params.id);
    if (!deleted{{TYPE}}) {
      return res.status(404).json({ message: '{{TYPE}} not found' });
    }
    res.status(200).json({ message: '{{TYPE}} deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
