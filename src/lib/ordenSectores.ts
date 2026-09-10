export const ORDEN_SECTORES = ['Inmobiliarias', 'Seguros', 'Reseñas Google', 'Autónomos / CV digital', 'Otras ideas'];

export function ordenarPorSector<T extends { 0: string }>(entradas: T[]): T[] {
	return [...entradas].sort((a, b) => {
		const iA = ORDEN_SECTORES.indexOf(a[0]);
		const iB = ORDEN_SECTORES.indexOf(b[0]);
		return (iA === -1 ? ORDEN_SECTORES.length : iA) - (iB === -1 ? ORDEN_SECTORES.length : iB);
	});
}
