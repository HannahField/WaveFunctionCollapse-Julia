struct RotationStrategy
  rotations::UInt8
end

struct MirrorStrategy
  mirror::Bool
end

struct TransformationStrategy
  rotation::RotationStrategy
  mirror::MirrorStrategy
end

nothing_strategy() = TransformationStrategy(RotationStrategy(0), MirrorStrategy(false))

right_rotated_strategy() = TransformationStrategy(RotationStrategy(1), MirrorStrategy(false))
turn_strategy() = TransformationStrategy(RotationStrategy(2), MirrorStrategy(false))
left_rotated_strategy() = TransformationStrategy(RotationStrategy(3), MirrorStrategy(false))

fully_rotated_strategies() = [nothing_strategy(), right_rotated_strategy(), turn_strategy(), left_rotated_strategy()]

horizontal_mirror_strategy() = TransformationStrategy(RotationStrategy(0), MirrorStrategy(true))
vertical_mirror_strategy() = TransformationStrategy(RotationStrategy(2), MirrorStrategy(true))
left_diagonal_mirror_strategy() = TransformationStrategy(RotationStrategy(1), MirrorStrategy(true))
right_diagonal_mirror_strategy() = TransformationStrategy(RotationStrategy(3), MirrorStrategy(true))

function image_transformation(transformation::TransformationStrategy, image)
  image_transformation(transformation.rotation, image_transformation(transformation.mirror, image))
end

function image_transformation(transformation::RotationStrategy, input_image)
  image = input_image
  for _ in 0:transformation.rotations
    image = rotr90(input_image)
  end
  image
end

function image_transformation(transformation::MirrorStrategy, image)
  if transformation.mirror
    image[end:-1:1, :]
  else
    image
  end
end
