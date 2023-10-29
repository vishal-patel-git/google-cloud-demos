class Supplier {
  constructor(
    readonly name: string,
    readonly address: string,
    readonly googlePlaceId: string,
    readonly createdAt: Date,
    readonly updatedAt: Date
  ) {}
}

export {Supplier};
