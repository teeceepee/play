/**
 * 从 [0, max) 中随机取出 count 个数字
 * @param max
 * @param count
 */
export function randomNumbers (max: number, count: number): number[] {
  const selected: number[] = []

  for (let i = 0; i < max; i++) {
    const remaining = max - i
    const p = (count - selected.length) / remaining

    const r = Math.random()

    if (r < p) {
      selected.push(i)
    }
  }

  return selected
}
